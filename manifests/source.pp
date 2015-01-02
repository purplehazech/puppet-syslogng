# == Define: syslogng::source
#
# Create a default file based syslog-ng source.
#
# === Parameters
#
# [*ensure*]
#  create or remove source, may be present or absent. Default: present
# [*conf_dir*]
#  configurations parent dir. Default: /etc/syslog-ng
#
define syslogng::source (
  $ensure   = present,
  $conf_dir = '/etc/syslog-ng'
){
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  $file_source = $::osfamily ? {
    'FreeBSD' => $title ? {
      'default' => "puppet:///modules/syslogng/source.d/${title}_freebsd.conf",
      default   => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/source.d/${title}.conf",
    },
    default   => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/source.d/${title}.conf",
  }

  file { "${conf_dir}/syslog-ng.conf.d/source.d/${title}.conf":
    ensure => $ensure_file,
    source => $file_source,
  }
}
