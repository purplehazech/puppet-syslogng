# == Define: syslogng::destination::syslog
#
#
define syslogng::destination::syslog (
  $ensure    = present,
  $conf_dir  = '/etc/syslog-ng',
  $services  = {
    'syslog-ng' => {},
  },
  $priority  = 00,
  $transport = 'tcp'
) {
  validate_re($ensure, ['^present$', '^absent$'])
  validate_absolute_path($conf_dir)
  validate_re($transport, ['^tcp$', '^udp$', '^tls$'])

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  file { "${conf_dir}/syslog-ng.conf.d/destination.d/syslog_${title}.conf":
    ensure  => $ensure_file,
    content => template("syslogng/syslog-ng.conf.d/destination.d/syslog.conf.erb"),
  }

  create_resources(syslogng::destination::syslog::service, $services, {
    ensure   => $ensure,
    conf_dir => $conf_dir,
    priority => $priority,
    destination => $title,
  })

}
