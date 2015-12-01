# Class: brew
#   Install robottelo_slave that can talk to Brew
#
class robottelo_slave::brew {
  include ::robottelo_slave

  ensure_packages([
    'brewkoji',
  ])

  $rh_mirror='http://download.lab.bos.redhat.com'
  Class['robottelo_slave'] ->
  yumrepo { 'rhpkg':
    baseurl  => "${rh_mirror}/rel-eng/dist-git/rhel/\$releasever/",
    gpgcheck => 0,
    enabled  => 1,
  } ->
  Package['brewkoji']
}
