#!/bin/bash -xe

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

sudo puppet apply -e 'class { robottelo_slave: }' --modulepath modules/ --verbose
