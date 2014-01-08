define periodicnoise::monitored_cron (
  $ensure                       = 'present',
  $command,
  $user                         = undef,
  $hour                         = undef,
  $minute                       = undef,
  $weekday                      = undef,
  $monthday                     = undef,
  $month                        = undef,
  $max_execution_start_delay    = undef,
  $execution_timeout,
  $notification_interval        = undef,
  $wrap_nagios_plugin           = undef,
  $nagios_notes_url             = undef,
  $nagios_freshness_threshold   = undef,
  $grace_time                   = undef,
  $monitor_ok                   = [],
  $monitor_warning              = [],
  $monitor_critical             = [],
  $monitor_unknown              = [],
  $nagios_template              = undef,
) {
  $event = $name

  include periodicnoise::params

  periodicnoise::cron { $event :
    ensure                    => $ensure,
    command                   => $command,
    user                      => $user ? { undef => $periodicnoise::params::cron_user, default => $user },
    hour                      => $hour ? { undef => $periodicnoise::params::cron_hour, default => $hour },
    minute                    => $minute ? { undef => $periodicnoise::params::cron_minute, default => $minute },
    weekday                   => $weekday ? { undef => $periodicnoise::params::cron_weekday, default => $weekday },
    monthday                  => $monthday ? { undef => $periodicnoise::params::cron_monthday, default => $monthday },
    month                     => $month ? { undef => $periodicnoise::params::cron_month, default => $month },
    max_execution_start_delay => $max_execution_start_delay ? { undef => $periodicnoise::params::pn_max_execution_start_delay, default => $max_execution_start_delay },
    execution_timeout         => $execution_timeout,
    use_syslog                => $periodicnoise::params::pn_use_syslog,
    event                     => $event,
    wrap_nagios_plugin        => $wrap_nagios_plugin ? { undef => $periodicnoise::params::pn_wrap_nagios_plugin, default => $wrap_nagios_plugin },
    grace_time                => $grace_time,
    monitor_ok                => $monitor_ok,
    monitor_warning           => $monitor_warning,
    monitor_critical          => $monitor_critical,
    monitor_unknown           => $monitor_unknown,
  }

  if ($ensure == 'present') {
    @@nagios_service { "$event on $periodicnoise::params::nagios_hostname":
      host_name             => $periodicnoise::params::nagios_hostname,
      use                   => $nagios_template ? {  undef => $periodicnoise::params::nagios_template, default => $nagios_template },
      notification_interval => $notification_interval,
      active_checks_enabled => $periodicnoise::params::nagios_active_checks_enabled,
      service_description   => $event,
      notes_url             => $nagios_notes_url,
      freshness_threshold   => $nagios_freshness_threshold,
    }
  }
}
