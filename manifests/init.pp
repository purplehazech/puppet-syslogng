# == Class: syslogng
#
# The syslog class is used to install install syslog-ng.
#
# === Parameters
# [*ensure*]
#  main module switch used to enable or disable installation and configuration
#  of syslog-ng package.
# [*conf_dir*]
#  base directory of syslog-ng config files.
#
class syslogng ($ensure = present, $conf_dir = '/etc/syslog-ng') {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure,
  }
  $ensure_directory = $ensure ? {
    present => directory,
    default => $ensure,
  }
  $ensure_service = $ensure ? {
    present => 'running',
    default => 'stopped',
  }
  $enable_service = $ensure ? {
    present => true,
    default => false,
  }

  package { 'syslog-ng':
    ensure => $ensure
  } -> file {
    "${conf_dir}/syslog-ng.conf":
      ensure  => $ensure_file,
      content => template('syslogng/syslog-ng.conf.erb');
    [
      "${conf_dir}/scl.conf",
      "${conf_dir}/modules.conf",
    ]:
      ensure => $ensure_file,
      source => [
        'puppet:///modules/syslogng/scl/scl.conf',
        'puppet:///modules/syslogng/scl/modules.conf',
      ];
    [
      "${conf_dir}/patterndb.d",
      "${conf_dir}/syslog-ng.conf.d",
      "${conf_dir}/syslog-ng.conf.d/destination.d",
      "${conf_dir}/syslog-ng.conf.d/filter.d",
      "${conf_dir}/syslog-ng.conf.d/source.d",
      "${conf_dir}/syslog-ng.conf.d/log.d",
      "${conf_dir}/syslog-ng.conf.d/option.d",
      "${conf_dir}/syslog-ng.conf.d/service.d",
    ]:
      ensure => $ensure_directory;
  } ~> service { 'syslog-ng':
    ensure => $ensure_service,
    enable => $enable_service,
  }
}
