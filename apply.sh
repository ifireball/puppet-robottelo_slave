#!/bin/bash -e

log() {
    echo "$@" 1>&2
}
die() {
    log "$@"
    exit 1
}
have_executable() {
    local exe_name="${1:?Executalbe name not passed to have_executable}"
    which "$exe_name" &> /dev/null
}

ensure_puppet() {
    if ! have_executable puppet; then
        # Attempt to install puppet if it is not installed, that will hopefully also
        # pull 'ruby' and 'gem'
        log 'WARNING: Puppet is not installed on this machine!'
        log 'INFO: Attepmting to install puppet automatically'
        if have_executable dnf; then
            dnf -q -y install puppet
        elif have_executable yum; then
            yum -q -y install puppet
        else
            false
        fi || \
        die 'ERROR: Cannot install puppet! Please install manually'
    fi
}

cmd_param_to_puppet() {
    local cmd_param="${1:?}"
    local value="${2:?}"
    local puppet_param="${cmd_param##--}"
    puppet_param="${puppet_param//[^[:alnum:]]/_}"
    echo "$puppet_param => '$value'"
}

PARSED_OPTS=$(
    getopt -o 'y' \
        --long 'noop' \
        --long 'brew' \
        --long 'auto-cloud-swarm,jenkins-master:,jenkins-user:,jenkins-pwd:' \
        -n "$0" \
        -- "$@"
) || exit 2
eval set -- "$PARSED_OPTS"

PUPPET_CLASS='robottelo_slave'
PUPPET_PARAMS=()
WARN_IF_MISSING=()
NOOP=''
CONFIRM='needed'

while true ; do
    case "$1" in
        -y) CONFIRM='' ;;
        --brew) PUPPET_CLASS='robottelo_slave::brew' ;;
        --auto-cloud-swarm)
            PUPPET_CLASS='robottelo_slave::auto_cloud_swarm'
            ;;
        --jenkins-master|--jenkins-user|--jenkins-pwd)
            PUPPET_PARAMS+=("$(cmd_param_to_puppet "$1" "$2")")
            WARN_IF_MISSING+=(jenkins_{user,pwd})
            shift ;;
        --noop) NOOP='echo NOOP:';;
        --) shift ; break ;;
        *) die "Internal error! (\$1 is $1)" ; exit 3 ;;
    esac
    shift
done

if [[ ${#PUPPET_PARAMS[@]} -gt 0 ]]; then
    echo "Running Puppet with the following class attributes:"
    printf "  %s\n" "${PUPPET_PARAMS[@]}"
fi

MISSING=($(
    comm -23 \
        <(printf "%s\n" "${WARN_IF_MISSING[@]}" | sort -u) \
        <(printf "%s\n" "${PUPPET_PARAMS[@]%% =>*}" | sort -u)
))
if [[ ${#MISSING[@]} -gt 0 ]]; then
    echo "The following Puppet class attributes are probably missing:"
    echo "  ${MISSING[*]}"
    if [[ "$CONFIRM" ]]; then
        read  -p "Continue? (Y/N): " YES
        [[ "${YES^^}" == Y ]] || die "You didn't say yes"
    fi
fi


$NOOP ensure_puppet

list=`gem list`
if ! echo "${list[@]}" | fgrep --word-regexp "librarian-puppet"; then
    $NOOP gem install librarian-puppet
fi

rm -rf modules
$NOOP librarian-puppet install --path modules/

$NOOP pushd modules
$NOOP ln -s ../ robottelo_slave
$NOOP popd
rm -rf .tmp

$NOOP sudo puppet apply \
    -e "class { '$PUPPET_CLASS': $(printf '%s, ' "${PUPPET_PARAMS[@]}") }" \
    --modulepath modules/ \
    --verbose
