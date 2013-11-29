require 'spec_helper'

describe 'periodicnoise::once', :type => :define do

  let (:title) { 'some_oncejob' }
  let (:params) {{
    :command           => 'some_once_command',
    :user              => 'root',
    :execution_timeout => '10m'
  }}

  it "should create a oncejob" do
    should contain_exec('some_oncejob') \
      .with_command('pn --timeout=10m --use-syslog -- some_once_command') \
      .with_user('root') \
      .with_require('Package[periodicnoise]')
  end

  context "with event set" do
    let (:params) {{
      :command           => 'some_once_command',
      :user              => 'root',
      :event             => 'some_event',
      :execution_timeout => '10m'
    }}
    it "should create a oncejob with event set" do
      should contain_exec('some_oncejob') \
        .with_command('pn --monitor-event=\'some_event\' --timeout=10m --use-syslog -- some_once_command')
    end
  end

  context "with stderr logging disabled" do
    let (:params) {{
      :command            => 'some_once_command',
      :user               => 'root',
      :disable_stderr_log => true,
      :execution_timeout  => '10m'
    }}
    it "should create a oncejob with stderr logging disabled" do
      should contain_exec('some_oncejob') \
        .with_command('pn --timeout=10m --no-stream-stderr --use-syslog -- some_once_command')
    end
  end

  context "with maximum execution start delay set to 2 minutes" do
    let (:params) {{
      :command                   => 'some_once_command',
      :user                      => 'root',
      :max_execution_start_delay => '2m',
      :execution_timeout         => '10m'
    }}
    it "should create a oncejob with maximum execution start delay set to 2 minutes" do
      should contain_exec('some_oncejob') \
        .with_command('pn --max-start-delay=2m --timeout=10m --use-syslog -- some_once_command')
    end
  end

  context "with kill already running instance enabled" do
    let (:params) {{
      :command               => 'some_once_command',
      :user                  => 'root',
      :kill_running_instance => true,
      :execution_timeout     => '10m'
    }}
    it "should create a oncejob with kill already running instance enabled" do
      should contain_exec('some_oncejob') \
        .with_command('pn --timeout=10m --kill-running --use-syslog -- some_once_command')
    end
  end

  context "with disabled stdout logging" do
    let (:params) {{
      :command            => 'some_once_command',
      :user               => 'root',
      :disable_stdout_log => true,
      :execution_timeout  => '10m'
    }}
    it "should create a oncejob with disabled stdout logging" do
      should contain_exec('some_oncejob') \
        .with_command('pn --timeout=10m --no-stream-stdout --use-syslog -- some_once_command')
    end
  end

  context "syslog disabled" do
    let (:params) {{
      :command           => 'some_once_command',
      :user              => 'root',
      :use_syslog        => false,
      :execution_timeout => '10m'
    }}
    it "should create a oncejob with syslog logging enabled" do
      should contain_exec('some_oncejob') \
        .with_command('pn --timeout=10m -- some_once_command')
    end
  end

  context "with execution timeout set to 2 minutes" do
    let (:params) {{
      :command            => 'some_once_command',
      :user               => 'root',
      :execution_timeout  => '2m'
    }}
    it "should create a oncejob with execution timeout set to 2 minutes" do
      should contain_exec('some_oncejob') \
        .with_command('pn --timeout=2m --use-syslog -- some_once_command')
    end
  end

  context "with wrap nagios plugin enabled" do
    let (:params) {{
      :command            => 'some_once_command',
      :user               => 'root',
      :wrap_nagios_plugin => true,
      :execution_timeout  => '10m'
    }}
    it "should create a oncejob with execution timeout set to 2 minutes" do
      should contain_exec('some_oncejob') \
        .with_command('pn --timeout=10m --use-syslog --wrap-nagios-plugin -- some_once_command')
    end
  end

  context "with exit codes remapped like puppet --detailed-exit-codes need it" do
    let (:params) {{
      :command            => 'puppet agent --test --detailed-exit-codes',
      :event              => 'some_event',
      :user               => 'root',
      :execution_timeout  => '10m',
      :monitor_ok         => [2],
      :monitor_critical   => [1, 4 ,6],
    }}
    it "should create a oncejob with execution timeout set to 10m suitable for wrapping puppet in --detailed-exit-codes mode" do
      should contain_exec('some_oncejob') \
        .with_command('pn --monitor-event=\'some_event\' --timeout=10m --use-syslog --monitor-ok=2 --monitor-critical=1 --monitor-critical=4 --monitor-critical=6 -- puppet agent --test --detailed-exit-codes')
    end
  end

  context "with all params enabled" do
    let (:params) {{
      :command                    => 'some_once_command',
      :user                       => 'root',
      :event                      => 'some_event',
      :disable_stderr_log         => true,
      :max_execution_start_delay  => '2m',
      :kill_running_instance      => true,
      :disable_stdout_log         => true,
      :use_syslog                 => true,
      :execution_timeout          => '2m',
      :wrap_nagios_plugin         => true
    }}
    it "should create a oncejob with event set" do
      should contain_exec('some_oncejob') \
        .with_command('pn --monitor-event=\'some_event\' --max-start-delay=2m --timeout=2m --kill-running --no-stream-stdout --no-stream-stderr --use-syslog --wrap-nagios-plugin -- some_once_command')
    end
  end

  context "with all exec specific parameters enabled" do
    let (:params) {{
      :command           => 'some_once_command',
      :user              => 'root',
      :execution_timeout => '10m',
      :creates           => '/some/file',
      :onlyif            => true,
      :refresh           => true,
      :refreshonly       => true,
      :tries             => 1,
      :try_sleep         => 0,
      :unless            => true,
    }}
    it "should create a oncejob" do
      should contain_exec('some_oncejob') \
        .with_command('pn --timeout=10m --use-syslog -- some_once_command') \
        .with_user('root') \
        .with_creates('/some/file') \
        .with_onlyif(true) \
        .with_refresh(true) \
        .with_refreshonly(true) \
        .with_tries(1) \
        .with_try_sleep(0) \
        .with_unless(true) \
        .with_require('Package[periodicnoise]')
    end
  end
end
