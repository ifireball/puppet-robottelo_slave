# Class: satellite6
#   Install the SAtellite 6 flavor of the robottelo_slave
#
class robottelo_slave::satellite6 {
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
