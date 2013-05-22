# == Define: syslogng::destination
#
# Create a syslog-ng destination. This facility is used by the main syslogng
# class to create destinations.
#
# === Parameters
#
# [*ensure*]
#  create or remove a destination, may be present or absent. Default: present
# [*conf_dir*]
#  configuration parent dir. Default: /etc/syslog-ng
# [*type*]
#  type of destination to create, currently file and syslog are supported.
#  Default: file
# [*options*]
#  The full hash of destinations as passed to the syslogng class
#
define syslogng::destination (
  $ensure   = present,
  $conf_dir = '/etc/syslog-ng',
  $type     = file,
  $services = {},
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  case $type {
    file: {
      file { "${conf_dir}/syslog-ng.conf.d/destination.d/${title}.conf":
        ensure => $ensure_file,
        source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/destination.d/${title}.conf"
      }
    }
    default:{
      # noop
    }
  }
}
