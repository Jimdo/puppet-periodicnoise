class periodicnoise::params (
  $cron_user     = $periodicnoise::defaults::cron_user,
  $cron_hour     = $periodicnoise::defaults::cron_hour,
  $cron_minute   = $periodicnoise::defaults::cron_minute,
  $cron_weekday  = $periodicnoise::defaults::cron_weekday,
  $cron_monthday = $periodicnoise::defaults::cron_monthday,
  $cron_month    = $periodicnoise::defaults::cron_month,

  $pn_max_execution_start_delay = undef,
  $pn_execution_timeout         = undef,
  $pn_kill_running_instance     = $periodicnoise::defaults::pn_kill_running_instance,
  $pn_disable_stdout_log        = $periodicnoise::defaults::pn_disable_stdout_log,
  $pn_disable_stderr_log        = $periodicnoise::defaults::pn_disable_stderr_log,
  $pn_use_syslog                = $periodicnoise::defaults::pn_use_syslog,
  $pn_wrap_nagios_plugin        = $periodicnoise::defaults::pn_wrap_nagios_plugin,

  $nagios_hostname              = $periodicnoise::defaults::nagios_hostname,
  $nagios_template              = $periodicnoise::defaults::nagios_template,
  $nagios_active_checks_enabled = undef,
) inherits periodicnoise::defaults {
}
