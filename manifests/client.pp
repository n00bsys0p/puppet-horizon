# == Define: horizon::client
#
# Download a Horizon client
define horizon::client (
  $ensure         = 'installed',
  $user           = 'horizon',
  $cache_dir      = '/usr/local/src',
  $package_suffix = '-node',
  $current        = true,
  $server_opts    = {}
) {
  $version = $title
  if $version == undef {
    fail('The version of the Horizon client is the title of the defined type')
  }

  $release_dir = "/var/lib/${user}/releases"
  $install_dir = "${release_dir}/hz-v${version}${package_suffix}"

  if $ensure == 'absent' {
    file { "horizon_v${version}":
      path   => $install_dir,
      ensure => absent,
      mode   => '0644'
    }
  } else {
    $download_url = "https://github.com/NeXTHorizon/hz-source/releases/download/hz-v${version}/hz-v${version}${package_suffix}.zip"
    wget::fetch { "download_horizon_client_${version}":
      source      => $download_url,
      destination => "${cache_dir}/hz-v${version}.zip",
      verbose     => false
    } ->
    exec { "extract_horizon_${version}":
      command => "unzip -d ${release_dir} ${cache_dir}/hz-v${version}.zip",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      user    => 'horizon',
      creates => "${install_dir}"
    } ->
    file { "horizon_${version}_conf":
      path    => "${install_dir}/conf/nhz.properties",
      ensure  => file,
      mode    => '0600',
      owner   => $user,
      group   => $user,
      content => template("${module_name}/nhz.properties.erb")
    }

    if $current == true {
      file { 'current_link':
        ensure  => link,
        target  => "${install_dir}",
        path    => "${release_dir}/current",
        mode    => '0644',
        require => Exec["extract_horizon_${version}"]
      }
    }
  }
}
