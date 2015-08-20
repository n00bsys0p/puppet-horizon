# == Class: horizon::service
#
class horizon::service {
  class { 'supervisord':
    install_pip => true
  }

  if $::horizon::client_version =~ /^4/ {
    $cmd_prefix = 'classes'
  } else {
    $cmd_prefix = 'nhz.jar'
  }

  $java_cmd = "${cmd_prefix}:lib/*:conf nxt.Nxt"
  $program_cmd = "/etc/alternatives/java -cp ${java_cmd}"
  supervisord::program { $::horizon::service_name:
    command         => $program_cmd,
    user            => $::horizon::user,
    numprocs        => '1',
    autostart       => true,
    autorestart     => true,
    stdout_logfile  => '/var/log/%(program_name)s.log',
    redirect_stderr => true,
    directory       => "/var/lib/${::horizon::user}/releases/current"
  }

  supervisord::supervisorctl { "restart_${::horizon::service_name}":
    command     => 'restart',
    process     => $::horizon::service_name,
    refreshonly => true
  }
}
