require 'spec_helper'

describe 'periodicnoise::cron', :type => :define do

  let (:title) { 'some_cronjob' }
  let (:params) {{
    :command  => 'some_cron_command',
    :user     => 'root',
    :minute   => 0,
    :hour     => 0
  }}

  it "should create a cronjob" do
    should contain_cron('some_cronjob') \
      .with_command('pn some_cron_command') \
      .with_user('root') \
      .with_minute(0) \
      .with_hour(0)
  end

  context "with event set" do
    let (:params) {{
      :command  => 'some_cron_command',
      :user     => 'root',
      :minute   => 0,
      :hour     => 0,
      :event    => 'some_event'
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -E some_event some_cron_command')
    end
  end

  context "with stderr logging disabled" do
    let (:params) {{
      :command  => 'some_cron_command',
      :user     => 'root',
      :minute   => 0,
      :hour     => 0,
      :disable_stderr_log => true
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -e false some_cron_command')
    end
  end

  context "with  execution interval set to 2m" do
    let (:params) {{
      :command            => 'some_cron_command',
      :user               => 'root',
      :minute             => 0,
      :hour               => 0,
      :execution_interval => '2m'
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -i 2m some_cron_command')
    end
  end

  context "with  kill already running instance enabled" do
    let (:params) {{
      :command                => 'some_cron_command',
      :user                   => 'root',
      :minute                 => 0,
      :hour                   => 0,
      :kill_running_instance  => true
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -k true some_cron_command')
    end
  end

  context "with disabled stdout logging" do
    let (:params) {{
      :command    => 'some_cron_command',
      :user       => 'root',
      :minute     => 0,
      :hour       => 0,
      :disable_stdout_log => true
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -o false some_cron_command')
    end
  end

  context "syslog enabled" do
    let (:params) {{
      :command    => 'some_cron_command',
      :user       => 'root',
      :minute     => 0,
      :hour       => 0,
      :use_syslog => true
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -s true some_cron_command')
    end
  end

  context "with execution timeout set to 2m" do
    let (:params) {{
      :command            => 'some_cron_command',
      :user               => 'root',
      :minute             => 0,
      :hour               => 0,
      :execution_timeout  => '2m'
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -t 2m some_cron_command')
    end
  end

  context "with all params enabled" do
    let (:params) {{
      :command  => 'some_cron_command',
      :user     => 'root',
      :minute   => 0,
      :hour     => 0,
      :event    => 'some_event',
      :disable_stderr_log => true,
      :execution_interval => '2m',
      :kill_running_instance  => true,
      :disable_stdout_log => true,
      :use_syslog => true,
      :execution_timeout  => '2m'
    }}
    it "should create a cronjob with event set" do
      should contain_cron('some_cronjob') \
        .with_command('pn -E some_event -e false -i 2m -k true -o false -s true -t 2m some_cron_command')
    end
  end

end