# == Class: horizon::configure
#
class horizon::configure {
  package { 'unzip':
    ensure => installed,
  }

  class { 'java':
    distribution => 'jre',
  }

  user { $::horizon::user:
    comment    => 'Horizon Service User',
    home       => "/var/lib/${::horizon::user}",
    ensure     => present,
    managehome => true,
    shell      => '/sbin/nologin',
    system     => true
  } ->
  file { 'hz_release_dir':
    path   => "/var/lib/${::horizon::user}/releases",
    owner  => $::horizon::user,
    group  => $::horizon::group,
    ensure => directory,
    mode   => '0644',
  }
}
