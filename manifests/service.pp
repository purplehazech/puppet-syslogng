# == Define: syslogng::service
#
# Create a syslog-ng service.
#
# === Parameters
#
# [*ensure*]
#  create or remove service, may be present or absent. Default: present
# [*conf_dir*]
#  configurations parent dir. Default: /etc/syslog-ng
#
define syslogng::service (
  $ensure   = present,
  $conf_dir = '/etc/syslog-ng'
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  file { "${conf_dir}/syslog-ng.conf.d/service.d/${title}.conf":
    ensure => $ensure_file,
    source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/service.d/${title}.conf"
  }
}
