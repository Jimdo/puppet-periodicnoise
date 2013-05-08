require 'spec_helper'

describe 'periodicnoise' do
  let (:facts) { Hash.new }
  let (:params) { {
    :send_as_host => 'somehost.example.com',
    :send_to_host => 'monitor.example.com',
  }}

  it 'should install the package periodicnoise in version 0.5 in order to provide the pn binary' do
    should contain_package('periodicnoise').with_ensure('0.5')
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
end
