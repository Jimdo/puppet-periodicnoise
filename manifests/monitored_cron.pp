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
  $nagios_check_freshness       = undef,
  $nagios_check_command         = undef,
  $nagios_max_check_attempts    = undef,
  $nagios_contact_groups        = undef
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
  }

  if ($ensure == 'present') {
    @@nagios_service { "$event on $periodicnoise::params::nagios_hostname":
      host_name                   => $periodicnoise::params::nagios_hostname,
      use                         => $periodicnoise::params::nagios_template,
      check_command               => $nagios_check_command ? { undef   => $periodicnoise::params::nagios_check_command, default => $nagios_check_command },
      check_interval              => $periodicnoise::params::nagios_check_interval,
      notification_interval       => $notification_interval ? { undef => $periodicnoise::params::notification_interval, default => $notification_interval },
      max_check_attempts          => $nagios_max_check_attempts ? { undef => $periodicnoise::params::nagios_max_check_attempts, default => $nagios_max_check_attempts },
      contact_groups              => $nagios_contact_groups ? { undef => $periodicnoise::params::nagios_contact_groups, default => $nagios_contact_groups },
      active_checks_enabled       => 0,
      service_description         => $event,
      notes_url                   => $nagios_notes_url ? { undef => $periodicnoise::params::nagios_notes_url, default => $nagios_notes_url },
      check_freshness             => $nagios_check_freshness ? { undef => $periodicnoise::params::nagios_check_freshness, default => $nagios_check_freshness },
      freshness_threshold         => $nagios_freshness_threshold ? { undef => $periodicnoise::params::nagios_freshness_threshold, default => $nagios_freshness_threshold },
    }
  }
}
