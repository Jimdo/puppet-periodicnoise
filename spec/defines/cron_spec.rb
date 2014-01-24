require 'spec_helper'

describe 'periodicnoise::cron', :type => :define do

  let (:title) { 'some_cronjob' }
  let (:params) {{
    :command           => 'some_cron_command',
    :user              => 'root',
    :minute            => 0,
    :hour              => 0,
    :execution_timeout => '10m'
  }}

  it "should create a cronjob" do
    should contain_cron('some_cronjob') \
      .with_command('pn --timeout=10m --use-syslog -- some_cron_command') \
      .with_user('root') \
      .with_minute(0) \
      .with_hour(0) \
      .with_weekday('*') \
      .with_monthday('*') \
      .with_month('*') \
      .with_require('Package[periodicnoise]')
  end

  context "with weekday, monthday and month set" do
    let (:params) {{
      :command           => 'some_cron_command',
      :user              => 'root',
      :minute            => 0,
      :hour              => 0,
      :weekday           => 1,
      :monthday          => 2,
      :month             => 3,
      :execution_timeout => '10m'
    }}
    it "should only run on 2nd of march if it is a monday" do
      should contain_cron('some_cronjob') \
        .with_weekday(1) \
        .with_monthday(2) \
        .with_month(3)
    end
  end

  context "with event set" do
    let (:params) {{
      :command           => 'some_cron_command',
      :user              => 'root',
      :minute            => 0,
      :hour              => 0,
      :event             => 'some_event',
      :execution_timeout => '10m'
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn --monitor-event=\'some_event\' --timeout=10m --use-syslog -- some_cron_command')
    end
  end

  context "with stderr logging disabled" do
    let (:params) {{
      :command            => 'some_cron_command',
      :user               => 'root',
      :minute             => 0,
      :hour               => 0,
      :disable_stderr_log => true,
      :execution_timeout  => '10m'
    }}
    it "should create a cronjob with stderr logging disabled" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=10m --no-stream-stderr --use-syslog -- some_cron_command')
    end
  end

  context "with maximum execution start delay set to 2 minutes" do
    let (:params) {{
      :command                   => 'some_cron_command',
      :user                      => 'root',
      :minute                    => 0,
      :hour                      => 0,
      :max_execution_start_delay => '2m',
      :execution_timeout         => '10m'
    }}
    it "should create a cronjob with maximum execution start delay set to 2 minutes" do
      should contain_cron('some_cronjob') \
        .with_command('pn --max-start-delay=2m --timeout=10m --use-syslog -- some_cron_command')
    end
  end

  context "with kill already running instance enabled" do
    let (:params) {{
      :command               => 'some_cron_command',
      :user                  => 'root',
      :minute                => 0,
      :hour                  => 0,
      :kill_running_instance => true,
      :execution_timeout     => '10m'
    }}
    it "should create a cronjob with kill already running instance enabled" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=10m --kill-running --use-syslog -- some_cron_command')
    end
  end

  context "with disabled stdout logging" do
    let (:params) {{
      :command            => 'some_cron_command',
      :user               => 'root',
      :minute             => 0,
      :hour               => 0,
      :disable_stdout_log => true,
      :execution_timeout  => '10m'
    }}
    it "should create a cronjob with disabled stdout logging" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=10m --no-stream-stdout --use-syslog -- some_cron_command')
    end
  end

  context "syslog disabled" do
    let (:params) {{
      :command           => 'some_cron_command',
      :user              => 'root',
      :minute            => 0,
      :hour              => 0,
      :use_syslog        => false,
      :execution_timeout => '10m'
    }}
    it "should create a cronjob with syslog logging enabled" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=10m -- some_cron_command')
    end
  end

  context "with execution timeout set to 2 minutes" do
    let (:params) {{
      :command            => 'some_cron_command',
      :user               => 'root',
      :minute             => 0,
      :hour               => 0,
      :execution_timeout  => '2m'
    }}
    it "should create a cronjob with execution timeout set to 2 minutes" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=2m --use-syslog -- some_cron_command')
    end
  end

  context "with wrap nagios plugin enabled" do
    let (:params) {{
      :command            => 'some_cron_command',
      :user               => 'root',
      :minute             => 0,
      :hour               => 0,
      :wrap_nagios_plugin => true,
      :execution_timeout  => '10m'
    }}
    it "should create a cronjob with execution timeout set to 2 minutes" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=10m --use-syslog --wrap-nagios-plugin -- some_cron_command')
    end
  end

  context "with exit codes remapped like puppet --detailed-exit-codes need it" do
    let (:params) {{
      :command            => 'puppet agent --test --detailed-exit-codes',
      :user               => 'root',
      :minute             => 0,
      :hour               => 0,
      :execution_timeout  => '10m',
      :monitor_ok         => [2],
      :monitor_critical   => [1, 4, 6],
    }}
    it "should create a cronjob with execution timeout set to 10m suitable for wrapping puppet in --detailed-exit-codes mode" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=10m --use-syslog --monitor-ok=2 --monitor-critical=1 --monitor-critical=4 --monitor-critical=6 -- puppet agent --test --detailed-exit-codes')
    end
  end

  context "with all params enabled" do
    let (:params) {{
      :command                    => 'some_cron_command',
      :user                       => 'root',
      :minute                     => 0,
      :hour                       => 0,
      :event                      => 'some_event',
      :disable_stderr_log         => true,
      :max_execution_start_delay  => '2m',
      :kill_running_instance      => true,
      :disable_stdout_log         => true,
      :use_syslog                 => true,
      :execution_timeout          => '2m',
      :wrap_nagios_plugin         => true
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn --monitor-event=\'some_event\' --max-start-delay=2m --timeout=2m --kill-running --no-stream-stdout --no-stream-stderr --use-syslog --wrap-nagios-plugin -- some_cron_command')
    end
  end

  context "absent" do
    let (:params) {{
      :ensure            => 'absent',
      :command           => 'some_cron_command',
      :minute            => 0,
      :hour              => 0,
      :execution_timeout => '10m'
    }}
    it "should contain absent cronjob" do
      should contain_cron('some_cronjob') \
        .with_command('pn --timeout=10m --use-syslog -- some_cron_command') \
        .with_minute(0) \
        .with_hour(0) \
        .with_ensure('absent')
    end
  end

  context "with a pre-command set" do
    let (:params) {{
      :command            => 'some_cron_command',
      :execution_timeout  => '2m',
      :pre_command        => '/run/me --before'
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('/run/me --before pn --timeout=2m --use-syslog -- some_cron_command')
    end

  end
end
