# == Define: syslogng::destination::syslog::logpath
#
#
define syslogng::destination::syslog::logpath (
  $ensure   = present,
  $conf_dir = '/etc/syslog-ng',
  $priority = 00,
  $destination = undef,
  $logpath = undef,
) {
  validate_re($ensure, ['^present$', '^absent$'])

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure,
  }

  $logpath_name = $logpath ? {
    undef   => $title,
    default => $logpath,
  }

  file { "${conf_dir}/syslog-ng.conf.d/log.d/${priority}_syslog_${title}.conf":
    ensure  => $ensure_file,
    content => template('syslogng/syslog-ng.conf.d/log.d/syslog.conf.erb'),
  }

}

