# == Class: horizon
#
# Full description of class horizon here.
#
# === Parameters
#
# Document parameters here.
#
# $client_version
#   The version of the Horizon client to install
# $user
#   The user under which to install the Horizon node
# $group
#   The group under which to install the Horizon node
# $service_name
#   The name of the supervisord program
# $server_opts
#   A hash of options to write to the Horizon configuration file
#
# === Examples
#
#  include ::horizon
#
#  ...or...
#
#  class { 'horizon':
#    $client_version => '3.9.2',
#    $user           => 'hz'
#    $group          => 'hz',
#    $service_name   => 'hzclient'
#    $server_opts    => {
#      'nhz.peerServerPort' => '7879',
#      'nhz.myHallmark'     => 'deadbeefcafe'
#    }
#  }
#
# === Authors
#
# Alex Shepherd <dev@alexshepherd.me>
#
# === Copyright
#
# Copyright 2015 Alex Shepherd, unless otherwise noted.
#
class horizon(
  $client_version = $::horizon::params::client_version,
  $user           = $::horizon::params::user,
  $group          = $::horizon::params::user,
  $service_name   = $::horizon::params::service_name,
  $server_opts    = $::horizon::params::server_opts
) inherits horizon::params {

  $home_dir = "/var/lib/${user}"

  class { '::horizon::configure': } ->
  ::horizon::client { $client_version:
    user        => $user,
    server_opts => $server_opts
  } ->
  class { '::horizon::service':
    require   => Horizon::Client[$client_version],
    subscribe => Horizon::Client[$client_version]
  }

}
