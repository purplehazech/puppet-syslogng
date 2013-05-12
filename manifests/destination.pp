# == Define: syslogng::destination
#
# Create a syslog-ng destination.
#
# === Parameters
#
# [*ensure*]
#  create or remove a destination, may be present or absent. Default: present
# [*conf_dir*]
#  configuration parent dir. Default: /etc/syslog-ng
#
define syslogng::destination (
  $ensure = present,
  $conf_dir = '/etc/syslog-ng'
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  file { "${conf_dir}/syslog-ng.conf.d/destination.d/${title}.conf":
    ensure => $ensure_file,
    source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/destination.d/${title}.conf"
  }
}
