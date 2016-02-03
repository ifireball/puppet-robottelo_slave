class robottelo_slave::install {

  ensure_packages([
    'python-devel',
    'python-pip',
    'python-virtualenv',
    'rubygem-hammer_cli_katello',
  ])

}
