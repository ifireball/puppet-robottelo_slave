#!/bin/bash -xe

gem list | grep librarian-puppet
librarian_installed=$?

if [[ $librarian_installed == 1 ]]; then
  gem install librarian-puppet
fi

rm -rf modules
librarian-puppet install --path modules/

pushd modules
ln -s ../ robottelo_slave
popd
rm -rf .tmp

sudo puppet apply -e 'class { robottelo_slave: }' --modulepath modules/ --verbose
