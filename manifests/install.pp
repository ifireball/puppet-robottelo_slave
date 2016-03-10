class robottelo_slave::install {

  ensure_packages([
    'python-devel',
    'python-pip',
    'python-virtualenv',
    'ruby-devel',
  ])

  ensure_packages(['hammer_cli_katello'], {
    'provider' => 'gem'
  })
  Package['ruby-devel'] -> Package['hammer_cli_katello']

}
