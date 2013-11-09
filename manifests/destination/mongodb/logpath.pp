# == Define: syslogng::destination::mongodb::logpath
#
# Define used to create the logpath for individual syslogng::destination
# needed for each mongodb destination.
#
# Do not use this class directly it is not considered part of the public api.
#
define syslogng::destination::mongodb::logpath (
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

  file { "${conf_dir}/syslog-ng.conf.d/log.d/${priority}_mongodb_${title}.conf":
    ensure  => $ensure_file,
    content => template('syslogng/syslog-ng.conf.d/log.d/mongodb.conf.erb'),
  }

}

