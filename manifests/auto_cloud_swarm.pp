# == Class: robottelo_slave::auto_cloud_swarm
#   Automatically setup everything needed to get a host from blank OS install up
#   to a fully functioning slave registered to Jenkins with the swarm plugin
#
# === Parameters
#
# [*jenkins_master*]
#   The jenkins master server to attach to
#
class robottelo_slave::auto_cloud_swarm(
  $jenkins_master = undef,
  $jenkins_user   = undef,
  $jenkins_pwd    = undef,
  $jenkins_labels = 'builders',
  $slave_user     = 'jenkins',
) {
  yumrepo { 'epel-temp':
    mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
    gpgcheck   => 0,
    enabled    => 1,
  } ->
  package {'epel-release':
    ensure => 'latest',
    before => [
      Package['mock', 'tito', 'git-annex', 'koji', 'npm'],
      Class['robottelo_slave'],
    ],
  }

  ensure_resource('group', $slave_user, { 'ensure' => 'present' })
  ensure_resource('user', $slave_user, { 'ensure' => 'present' })
  User<| title == $slave_user |> {
    managehome => true,
    gid        => $slave_user,
    groups     => [$slave_user, 'mock'],
    require    => Package['mock'],
  }
  User[$slave_user] -> Class['robottelo_slave']

  include ::robottelo_slave::brew
  ensure_packages(['mock'])

  if $jenkins_master {
    ensure_packages(['wget'])
    Package['wget'] ->
    class { '::jenkins::slave':
      masterurl                => $jenkins_master,
      ui_user                  => $jenkins_user,
      ui_pass                  => $jenkins_pwd,
      version                  => '2.0',
      executors                => '1',
      manage_slave_user        => false,
      slave_user               => $slave_user,
      slave_home               => "/home/${slave_user}",
      disable_ssl_verification => true,
      labels                   => $jenkins_labels,
    }
    file {
      '/etc/systemd/system/jenkins-slave.service':
        source => "puppet:///modules/${module_name}/jenkins-slave.service",
        mode   => '0644';
      '/usr/local/sbin/jenkins-slave':
        source => "puppet:///modules/${module_name}/jenkins-slave",
        mode    => '0700';
    } ~>
    Service['jenkins-slave']
  }
}
