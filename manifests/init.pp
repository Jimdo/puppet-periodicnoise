# Install/configure something here
class periodicnoise(send_as_host, send_to_host) {
  $send_as_host = $send_as_host
  $send_to_host = $send_to_host
  package{ 'periodicnoise': ensure => present }
  file { '/etc/periodicnoise/config.ini' :
    ensure  => present,
    content => template('periodicnoise/nsca.erb'),
  }
}
