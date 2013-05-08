# Install/configure something here
class periodicnoise($send_as_host = undef, $send_to_host = undef) {
  # temporary, to allow parameter changes
  package{ 'periodicnoise': ensure => '0.5'}
  file { '/etc/periodicnoise': ensure => directory}
  file { '/etc/periodicnoise/config.ini' :
    ensure  => present,
    content => template('periodicnoise/nsca.erb'),
    require => Package['periodicnoise'],
  }
}
