define periodicnoise::cron (
  $ensure                    = 'present',
  $command,
  $user                      = undef,
  $hour                      = undef,
  $minute                    = undef,
  $weekday                   = undef,
  $monthday                  = undef,
  $month                     = undef,
  $max_execution_start_delay = undef,
  $execution_timeout,
  $kill_running_instance     = undef,
  $disable_stdout_log        = undef,
  $disable_stderr_log        = undef,
  $use_syslog                = undef,
  $wrap_nagios_plugin        = undef,
  $event                     = undef,
  $grace_time                = undef,
  $monitor_ok                = [],
  $monitor_warning           = [],
  $monitor_critical          = [],
  $monitor_unknown           = [],
  $pre_command               = undef,
  $retries                   = undef,
) {
  include periodicnoise::params

  if ($max_execution_start_delay != undef) and ("$max_execution_start_delay" =~ /^[0-9]+$/) {
    fail("max_execution_start_delay is missing unit of measure like 3h4m5s for 3 hours, 4 minutes and 5 seconds")
  }
  if ($grace_time != undef) and ("$grace_time" =~ /^[0-9]+$/) {
    fail("grace_time is missing unit of measure like 3h4m5s for 3 hours, 4 minutes and 5 seconds")
  }
  if ($execution_timeout != undef) and ("$execution_timeout" =~ /^[0-9]+$/) {
    fail("execution_timeout is missing unit of measure like 3h4m5s for 3 hours, 4 minutes and 5 seconds")
  }

  # Variables used in command.erb
  $_max_execution_start_delay = $max_execution_start_delay ? { undef => $periodicnoise::params::pn_max_execution_start_delay, default => $max_execution_start_delay }
  $_execution_timeout         = $execution_timeout
  $_kill_running_instance     = $kill_running_instance ? { undef => $periodicnoise::params::pn_kill_running_instance, default => $kill_running_instance }
  $_disable_stdout_log        = $disable_stdout_log ? { undef => $periodicnoise::params::pn_disable_stdout_log, default => $disable_stdout_log }
  $_disable_stderr_log        = $disable_stderr_log ? { undef => $periodicnoise::params::pn_disable_stderr_log, default => $disable_stderr_log }
  $_use_syslog                = $use_syslog ? { undef => $periodicnoise::params::pn_use_syslog, default => $use_syslog }
  $_wrap_nagios_plugin        = $wrap_nagios_plugin ? { undef => $periodicnoise::params::pn_wrap_nagios_plugin, default => $wrap_nagios_plugin }
  $_pre_command               = $pre_command ? { undef => undef, default => "${pre_command} " }
  $_retries                   = $retries ? { undef => $periodicnoise::params::pn_retries, default => $retries }

  cron { $name:
    ensure    => $ensure,
    command   => template('periodicnoise/command.erb'),
    user      => $user ? { undef => $periodicnoise::params::cron_user, default => $user },
    hour      => $hour ? { undef => $periodicnoise::params::cron_hour, default => $hour },
    minute    => $minute ? { undef => $periodicnoise::params::cron_minute, default => $minute },
    weekday   => $weekday ? { undef => $periodicnoise::params::cron_weekday, default => $weekday },
    monthday  => $monthday ? { undef => $periodicnoise::params::cron_monthday, default => $monthday },
    month     => $month ? { undef => $periodicnoise::params::cron_month, default => $month },
    require   => Package['periodicnoise']
  }
}
