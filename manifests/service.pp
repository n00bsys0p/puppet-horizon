# == Class: horizon::service
#
class horizon::service {
  class { 'supervisord':
    install_pip => true
  }

  supervisord::program { $::horizon::service_name:
    command         => '/etc/alternatives/java -cp classes:lib/*:conf nxt.Nxt',
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
