# == Class: horizon::params
#
class horizon::params {
  $user  = 'horizon'
  $group = 'horizon'

  $client_version = '4.0e'
  $service_name   = 'horizon'
  $server_opts    = {}
}
