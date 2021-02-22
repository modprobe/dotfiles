PROJECT_ROOT=${PROJECT_ROOT:-$HOME/insided/dev}

if [[ ! -d $PROJECT_ROOT ]]
then
    return 1
fi

VAGRANT_DIR=${PROJECT_ROOT}/vagrant-ansible

vssh() {
    local old_pwd=$(pwd)
    cd VAGRANT_DIR &>/dev/null

    if [[ "$#" -eq 0 ]]
    then
        command vagrant ssh
    else
        command vagrant ssh -c "${@:1}"
    fi

    cd ${old_pwd} &>/dev/null
}

alias vdir="cd ${VAGRANT_DIR}"
alias cbdir="cd ${PROJECT_ROOT}/community-backend"

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

    export AWS_PROFILE=$prof
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

shorten_region() {
  local long_region=${1:-AWS_REGION}

  echo "$long_region" | gsed -rn 's/(\w{2})\-(\w{1})\w+\-([0-9]{1})/\1\2\3/p'
}

function ec2 () {
  if [[ -z $AWS_PROFILE ]]
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

  echo ">> ssh ${AWS_PROFILE}-${short_region} > ssh ${ip}"

  ssh -tA $AWS_PROFILE-$short_region -- ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $ip
}

alias tp="open -a TablePlus"

aws_mfa_secret() {
  local item_name="AWS"
  local otp_url=`op get item AWS | jq '.details.sections[] | select(.fields) | .fields[] | select(.n | contains("TOTP")) | .v'`
  local secret=$(OTP_URL=${otp_url} python3 -c 'import os; from urllib.parse import urlparse; from urllib.parse import parse_qs; print(parse_qs(urlparse(os.environ.get("OTP_URL")).query)["secret"][0])')

  echo $(oathtool -b --totp "${secret}")
}