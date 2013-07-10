define periodicnoise::once (
  $command,
  $execution_timeout,
  $user                      = undef,
  $creates                   = undef,
  $onlyif                    = undef,
  $refresh                   = undef,
  $refreshonly               = undef,
  $tries                     = undef,
  $try_sleep                 = undef,
  $unless                    = undef,
  $max_execution_start_delay = undef,
  $kill_running_instance     = undef,
  $disable_stdout_log        = undef,
  $disable_stderr_log        = undef,
  $use_syslog                = undef,
  $wrap_nagios_plugin        = undef,
  $event                     = undef
) {
  include periodicnoise::params

  # Variables used in command.erb
  $_max_execution_start_delay = $max_execution_start_delay ? { undef => $periodicnoise::params::pn_max_execution_start_delay, default => $max_execution_start_delay }
  $_execution_timeout         = $execution_timeout
  $_kill_running_instance     = $kill_running_instance ? { undef => $periodicnoise::params::pn_kill_running_instance, default => $kill_running_instance }
  $_disable_stdout_log        = $disable_stdout_log ? { undef => $periodicnoise::params::pn_disable_stdout_log, default => $disable_stdout_log }
  $_disable_stderr_log        = $disable_stderr_log ? { undef => $periodicnoise::params::pn_disable_stderr_log, default => $disable_stderr_log }
  $_use_syslog                = $use_syslog ? { undef => $periodicnoise::params::pn_use_syslog, default => $use_syslog }
  $_wrap_nagios_plugin        = $wrap_nagios_plugin ? { undef => $periodicnoise::params::pn_wrap_nagios_plugin, default => $wrap_nagios_plugin }

  exec { $name:
    command     => template('periodicnoise/command.erb'),
    user        => $user ? { undef                        => $periodicnoise::params::cron_user, default => $user },
    creates     => $creates,
    onlyif      => $onlyif,
    refresh     => $refresh,
    refreshonly => $refreshonly,
    tries       => $tries,
    try_sleep   => $try_sleep,
    unless      => $unless,
    require     => Package['periodicnoise']
  }
}
