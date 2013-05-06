define periodicnoise::cron (
  $command,
  $user,
  $minute,
  $hour,
  $weekday = '*',
  $monthday = '*',
  $month = '*',
  $event = undef,
  $disable_stderr_log = undef,
  $max_execution_start_delay = undef,
  $kill_running_instance = undef,
  $disable_stdout_log = undef,
  $use_syslog = undef,
  $execution_timeout = undef,
  $wrap_nagios_plugin = undef ){

  $_disable_stderr_log = $disable_stderr_log ? {
    true  => true,
    default => false
  }

  $_kill_running_instance = $kill_running_instance ? {
    true  => true,
    default => false
  }

  $_disable_stdout_log = $disable_stdout_log ? {
    true  => true,
    default => false
  }

  $_use_syslog = $use_syslog ? {
    true  => true,
    default => false
  }

  $_wrap_nagios_plugin = $wrap_nagios_plugin ? {
    true  => true,
    default => false
  }

  cron { $name:
    command   => template('periodicnoise/cron.erb'),
    user      => $user,
    minute    => $minute,
    hour      => $hour,
    weekday   => $weekday,
    monthday  => $monthday,
    month     => $month,
    require   => Package['periodicnoise']
  }
}
