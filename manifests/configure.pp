# == Class: horizon::configure
#
class horizon::configure {
  package { 'unzip':
    ensure => installed,
  }

  class { 'java':
    distribution => 'jre',
  }

  File {
    owner  => $::horizon::user,
    group  => $::horizon::group
  }

  user { $::horizon::user:
    comment    => 'Horizon Service User',
    home       => $::horizon::home_dir,
    ensure     => present,
    managehome => true,
    shell      => '/sbin/nologin',
    system     => true
  } ->
  file { 'hz_release_dir':
    path   => "${::horizon::home_dir}/releases",
    ensure => directory,
    mode   => '0700',
  } ->
  file { 'hz_src_dir':
  path   => "${::horizon::home_dir}/src",
  ensure => directory,
  mode   => '0700',
  }
}
