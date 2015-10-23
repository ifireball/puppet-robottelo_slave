# == Class: robottelo_slave
#
# Setup and configure a Jenkins slave for use by SatelliteQE
#
class robottelo_slave () {

  include ::slave
  include ::libvirt

  Class['slave'] ->
  class { '::robottelo_slave::install': } ->
  class { '::robottelo_slave::config': }

}
