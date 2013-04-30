define periodicnoise::cron (
  $command,
  $user,
  $minute,
  $hour,
  $event = undef,
  $disable_stderr_log = undef,
  $execution_interval = undef,
  $kill_running_instance = undef,
  $disable_stdout_log = undef,
  $use_syslog = undef,
  $execution_timeout = undef ){

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

  cron { $name:
    command => template('periodicnoise/cron.erb'),
    user    => $user,
    minute  => $minute,
    hour    => $hour
  }
}
