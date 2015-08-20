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
#
# === Examples
#
#  include ::horizon
#
#  class { 'horizon':
#    $client_version = '3.9.2'
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
  $client_version = $horizon::params::client_version,
  $user           = $horizon::params::user,
  $group          = $horizon::params::user
) inherits horizon::params {
  require ::horizon::configure

  package { 'unzip':
    ensure => installed,
  }

  class { 'java':
    distribution => 'jre',
  }

  ::horizon::client { $client_version: }
}
