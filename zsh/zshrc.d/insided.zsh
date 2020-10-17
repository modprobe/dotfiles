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

alias ccache="vssh clear_cache"