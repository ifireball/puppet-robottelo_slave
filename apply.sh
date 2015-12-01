#!/bin/bash -xe

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

ensure_puppet

list=`gem list`
if ! echo "${list[@]}" | fgrep --word-regexp "librarian-puppet"; then
    gem install librarian-puppet
fi

rm -rf modules
librarian-puppet install --path modules/

pushd modules
ln -s ../ robottelo_slave
popd
rm -rf .tmp

PARSED_OPTS=$(getopt -o '' --long satellite6 -n "$0" -- "$@") \
|| exit 2
eval set -- "$PARSED_OPTS"

PUPPET_CLASS='robottelo_slave'

while true ; do
    case "$1" in
        --satellite6) PUPPET_CLASS='robottelo_slave::satellite6' ;;
        --) shift ; break ;;
        *) die "Internal error!" ; exit 3 ;;
    esac
    shift
done

sudo puppet apply -e "class { '$PUPPET_CLASS': }" --modulepath modules/ --verbose
