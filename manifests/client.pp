# == Define: horizon::client
#
# Download a Horizon client
define horizon::client (
  $ensure    = 'installed',
  $user      = 'horizon',
  $cache_dir = '/usr/local/src',
  $current   = true
) {
  include ::horizon

  $version = $title
  if $version == undef {
    fail('The version of the Horizon client is the title of the defined type')
  }

  if $ensure == 'absent' {
    file { "horizon_v${version}":
      path   => "/var/lib/${user}/releases/hz-${version}",
      ensure => absent,
      mode   => '0644'
    }
  } else {
    $download_url = "https://github.com/NeXTHorizon/hz-source/releases/download/hz-v${version}/hz-v${version}-node.zip"
    wget::fetch { "download_horizon_client_${version}":
      source      => $download_url,
      destination => "${cache_dir}/hz-v${version}.zip",
      verbose     => false
    } ->
    exec { "extract_horizon_${version}":
      command => "unzip -d /var/lib/${user}/releases ${cache_dir}/hz-v${version}.zip",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      user    => 'horizon',
      creates => "/var/lib/${user}/releases/hz-v${version}-node"
    }

    if $current == true {
      file { 'current_link':
        ensure  => link,
        target  => "/var/lib/horizon/releases/hz-v${version}-node",
        path    => '/var/lib/horizon/releases/current',
        mode    => '0644',
        require => Exec["extract_horizon_${version}"]
      }
    }
  }
}
