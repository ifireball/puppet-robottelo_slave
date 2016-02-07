class robottelo_slave::install {

  ensure_packages([
    'python-devel',
    'python-pip',
    'python-virtualenv',
  ])

  ensure_packages(['hammer_cli_katello'], {
    'provider' => 'gem'
  })

}
