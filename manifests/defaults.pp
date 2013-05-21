class periodicnoise::defaults {
  $cron_hour     = '*'
  $cron_minute   = '*'
  $cron_weekday  = '*'
  $cron_monthday = '*'
  $cron_month    = '*'
  $cron_user     = 'root'

  $pn_max_execution_start_delay = '1m'
  $pn_execution_timeout         = '12h'
  $pn_kill_running_instance     = false
  $pn_disable_stdout_log        = false
  $pn_disable_stderr_log        = false
  $pn_use_syslog                = true
  $pn_wrap_nagios_plugin        = false

  $nagios_hostname              = $::fqdn
  $nagios_template              = 'generic-service'
  $nagios_check_command         = 'check-dummyhost-alive'
  $nagios_notification_interval = 24 * 60
  $nagios_max_check_attempts    = 1
}