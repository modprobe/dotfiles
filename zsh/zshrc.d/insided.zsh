PROJECT_ROOT=${PROJECT_ROOT:-$HOME/insided/dev}

if [[ ! -d $PROJECT_ROOT ]]
then
    return 1
fi

alias ccache="echo 'flush_all' | nc 127.0.0.1 11211; echo 'flushall' | nc 127.0.0.1 6379"

if [[ -z "$AWS_PROFILE" ]]
then
  export AWS_PROFILE=staging
fi

aws_profile () {
    prof=$(aws configure list-profiles | fzf --history=${HOME}/.cache/aws_profiles --reverse --height=10)

    if [[ -z "$prof" ]]
    then
        unset AWS_PROFILE
        return 1
    fi

    awsume "$prof"
}

alias ap="aws_profile"

aws_region () {
    prof=$(aws ec2 describe-regions | fzf --history=${HOME}/.cache/aws_regions --reverse --height=10)

    if [[ -z "$prof" ]]
    then
        unset AWS_REGION
        return 1
    fi

    export AWS_REGION=$prof
}

alias ar="aws_region"


aws_console() {
  if [[ $# -gt 3 ]] || [[ $1 == "--help" ]]
  then
    echo -e "USAGE:\n  $0 [service]\n  $0 profile service\n  $0 profile service short_region"
    return 1
  fi

  if [[ $# -eq 0 ]]
  then
    awsume -c
  elif [[ $# -eq 1 ]]
  then
    awsume -cs $1
  elif [[ $# -eq 2 ]]
  then 
    awsume $1 -cs $2
  elif [[ $# -eq 3 ]]
  then
    awsume $1 -cs $2 --region "$(long_region $3)"
  fi
}

alias awsc="aws_console"

shorten_region() {
  local long_region=${1:-AWS_REGION}

  echo "$long_region" | gsed -rn 's/(\w{2})\-(\w{1})\w+\-([0-9]{1})/\1\2\3/p'
}

long_region() {
  declare -A REGION_MAPPING=(
    ["euw1"]="eu-west-1"
    ["usw2"]="us-west-2"
  )

  if [[ "$#" -ne 1 ]]; then 
    echo "USAGE: long_region <abbr>"
    return 1
  fi

  local long_name="${REGION_MAPPING[$1]}"
  if [[ -z "$long_name" ]]; then 
    echo "unknown short region"
    return 1
  fi

  echo $long_name
}

function ec2 () {
  if [[ -z $AWSUME_PROFILE ]]
  then
    aws_profile
  fi

  local selected_instance
  local private_ip
  local public_ip
  local ssh_host
  local short_region

  selected_instance=$(aws ec2 describe-instances \
    | jq '.Reservations | [.[] | .Instances] | flatten | [.[] | {Tags: [.Tags[]? | select(.Key == "Environment" or .Key == "Name") | .Value ] | sort, PrivateIpAddress, PublicIpAddress, InstanceId, ImageId, InstanceType, State: .State.Name}] | .[]' -c \
    | sort -u \
    | fzf --sync --preview "echo {} | jq ." --preview-window 'up:40%')

  if [[ -z "$selected_instance" ]]
  then
    return 1
  fi

  private_ip=$(echo $selected_instance | jq -r .PrivateIpAddress)
  ip=$(echo $selected_instance | jq -r .PublicIpAddress)

  if [[ "$ip" == "null" ]]; then
    ip=$private_ip
  fi

  if [[ -z $AWS_REGION ]]
  then
    export AWS_REGION=$(aws configure get region)
  fi

  short_region=$(shorten_region $AWS_REGION)

  if [[ -z $short_region ]]
  then
    echo "Cannot determine jump host for '$AWS_REGION'"
    return 1
  fi

  echo ">> ssh ${AWSUME_PROFILE}-${short_region} > ssh ${ip}"

  ssh -tA $AWSUME_PROFILE-$short_region.ssh.insided.com -- ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $ip
}

declare -A ES_ENDPOINTS=(
  ["staging-euw1"]="vpc-staging-elasti-1mr4bcoc2nw1-n6bh7mvtx6j2ulrbism37ieloq.eu-west-1.es.amazonaws.com"
  ["production-euw1"]="vpc-product-elasti-1lh092lprrnpk-e3l23gkozywtkme3fyke7i2ghe.eu-west-1.es.amazonaws.com"
  ["production-usw2"]="vpc-product-elasti-1iyp7yh14htww-pglmenmto32yjpxtrbzzocxnbe.us-west-2.es.amazonaws.com"
)

IAM_USERNAME=alex.timmermann

es_tunnel() {
  local env=$1

  if [[ "$#" -ne 1 ]]
  then
    echo "USAGE: es_tunnel <staging-euw1|production-euw1|production-usw2>"
    return 1
  fi

  local endpoint="${ES_ENDPOINTS[$env]}"

  if [[ -z "$endpoint" ]]
  then
    echo "USAGE: es_tunnel <staging-euw1|production-euw1|production-usw2>"
    return 1
  fi

  ssh -L 8443:${endpoint}:443 $IAM_USERNAME@$env.ssh.insided.com -N &
  open https://localhost:8443/_plugin/kibana
}
