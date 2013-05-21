require 'spec_helper'

describe 'periodicnoise::monitored_cron', :type => :define do
  let (:title) { 'some_monitored_cron' }

  context 'with default params' do
    let (:params) {{
      :command           => 'some_cron_command',
      :hour              => 0,
      :minute            => 0,
      :execution_timeout => '10m'
    }}

    it 'should create a periodicnoise cron job' do
      should contain_periodicnoise__cron('some_monitored_cron') \
        .with_command('some_cron_command') \
        .with_hour(0) \
        .with_minute(0) \
        .with_weekday('*') \
        .with_monthday('*') \
        .with_month('*') \
        .with_event('some_monitored_cron') \
        .with_execution_timeout('10m') \
        .with_use_syslog(true)
    end
  end

  context 'with custom execution delay and timeout' do
    let (:params) {{
      :command                   => 'some_cron_command',
      :hour                      => 0,
      :minute                    => 0,
      :max_execution_start_delay => '5m',
      :execution_timeout         => '6h'
    }}

    it 'should create a periodicnoise cron job with custom execution delay and timeout' do
      should contain_periodicnoise__cron('some_monitored_cron') \
        .with_max_execution_start_delay('5m') \
        .with_execution_timeout('6h')
    end
  end

  context 'with custom Nagios notification interval' do
    let (:params) {{
      :command               => 'some_cron_command',
      :hour                  => 0,
      :minute                => 0,
      :notification_interval => 12 * 60,
      :execution_timeout     => '6h'
    }}

    it 'should create a periodicnoise cron job' do
      should contain_periodicnoise__cron('some_monitored_cron')
    end
  end
end
