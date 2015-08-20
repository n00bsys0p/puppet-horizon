# == Class: horizon::configure
#
class horizon::configure (
  $user  = $horizon::user,
  $group = $horizon::group
) {
  include ::horizon

  user { $user:
    comment    => 'Horizon Service User',
    home       => "/var/lib/${user}",
    ensure     => present,
    managehome => true,
    shell      => '/sbin/nologin',
    system     => true
  } ->
  file { 'hz_release_dir':
    path   => "/var/lib/${user}/releases",
    owner  => $user,
    group  => $group,
    ensure => directory,
    mode   => '0644',
  }
}
