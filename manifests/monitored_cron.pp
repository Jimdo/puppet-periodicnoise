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
  $pre_command                  = undef,
  $retries                      = undef,
) {
  $event = $name

  include periodicnoise::params

  if ($nagios_freshness_threshold != undef) and ($nagios_freshness_threshold !~ /^(((\d+)([a-z]+))+|0)$/) {
    warning("nagios_freshness_threshold should have a unit of measure like 3h4m5s for 3 hours, 4 minutes and 5 seconds")
  }

  if ($notification_interval != undef) and ($notification_interval !~ /^(((\d+)([a-z]+))+|0)$/) {
    warning("notification_interval should have a unit of measure like 3h4m5s for 3 hours, 4 minutes and 5 seconds")
  }

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
    pre_command               => $pre_command,
    retries                   => $retries,
  }

  if ($ensure == 'present') {
    case $notification_interval {
      undef : {
        $_notification_interval = undef
      }
      /^[1-9][0-9]*$/ : {
        $_notification_interval = $notification_interval
      }
      default : {
        $_notification_interval = duration($notification_interval) / (1000 * 1000 * 1000) # /
      }
    }
    case $nagios_freshness_threshold {
      undef : {
        $_nagios_freshness_threshold = undef
      }
      /^[1-9][0-9]*$/ : {
        $_nagios_freshness_threshold = $nagios_freshness_threshold
      }
      default : {
        $_nagios_freshness_threshold = duration($nagios_freshness_threshold) / (1000 * 1000 * 1000) # /
      }
    }

    @@nagios_service { "$event on $periodicnoise::params::nagios_hostname":
      host_name             => $periodicnoise::params::nagios_hostname,
      use                   => $nagios_template ? {  undef => $periodicnoise::params::nagios_template, default => $nagios_template },
      notification_interval => $_notification_interval,
      active_checks_enabled => $periodicnoise::params::nagios_active_checks_enabled,
      service_description   => $event,
      notes_url             => $nagios_notes_url,
      freshness_threshold   => $_nagios_freshness_threshold,
    }
  }
}
