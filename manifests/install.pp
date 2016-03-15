class robottelo_slave::install {

  ensure_packages([
    'python-devel',
    'python-pip',
    'python-virtualenv',
    'ruby-devel',
    'qemu-img',
    'libguestfs-tools',
    'libvirt',
  ])

  ensure_packages(['hammer_cli_katello'], {
    'provider' => 'gem'
  })
  Package['ruby-devel'] -> Package['hammer_cli_katello']

  service { 'libvirtd':
    ensure  => 'running',
    require => Package['libvirt'],
  }
}
