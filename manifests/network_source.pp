# == Define: syslogng::network_source
#
# Create a syslog-ng network source (listener).
#
# === Parameters
#
# [*ensure*]
#  create or remove source, may be present or absent. Default: present
# [*conf_dir*]
#  configurations parent dir. Default: /etc/syslog-ng
#

define syslogng::network_source (
  $ensure              = present,
  $conf_dir            = '/etc/syslog-ng',
  $source_ip           = '0.0.0.0',
  $tcp_port            = undef,
  $tcp_max_connections = undef,
  $udp_port            = undef,
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  file { "${conf_dir}/syslog-ng.conf.d/source.d/${title}.conf":
    ensure => $ensure_file,
    content => template('syslogng/syslog-ng.conf.d/source.d/syslog.conf.erb'),
  }
  
}
