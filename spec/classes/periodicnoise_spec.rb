require 'spec_helper'

describe 'periodicnoise' do
  let (:facts) { Hash.new }
  let (:params) { {
    :send_as_host => 'somehost.example.com',
    :send_to_host => 'monitor.example.com',
  }}

  it 'should install the package periodicnoise in order to provide the pn binary' do
    should contain_package('periodicnoise').with_ensure('present')
  end

  it 'should configure periodicnoise globally for NSCA helpers in oder to see failures in nagios' do
    should contain_file('/etc/periodicnoise').with_ensure('directory')
    should contain_file('/etc/periodicnoise/config.ini')\
      .with_ensure('present') \
      .with_require('Package[periodicnoise]') \
      .with_content(%r{send_nsca}) \
      .with_content(%r{somehost.example.com}) \
      .with_content(%r{monitor.example.com})
  end

  it 'should be configured globally to send messages to one host' do
    should contain_file('/etc/periodicnoise/config.ini')\
      .with_content(Regexp.new(Regexp.escape('OK       = printf "somehost.example.com;%(event);0;%(message)\n" |/usr/sbin/send_nsca -H monitor.example.com -d ";"'))) \
      .with_content(%r{\nWARNING}) \
      .with_content(%r{\nCRITICAL}) \
      .with_content(%r{\nUNKNOWN})
  end

  context 'send to multiple hosts' do
    let (:params) {{
      :send_as_host => 'somehost.example.com',
      :send_to_host => ['monitor1.example.com', 'monitor2.example.com'],
    }}
    it 'should be configured globally to send messages to 2 hosts' do
      should contain_file('/etc/periodicnoise/config.ini')\
        .with_content(Regexp.new(Regexp.escape('OK       = printf "somehost.example.com;%(event);0;%(message)\n" |/usr/sbin/send_nsca -H monitor1.example.com -d ";";printf "somehost.example.com;%(event);0;%(message)\n" |/usr/sbin/send_nsca -H monitor2.example.com -d ";";'))) \
        .with_content(%r{\nWARNING}) \
        .with_content(%r{\nCRITICAL}) \
        .with_content(%r{\nUNKNOWN})
    end
  end
end
