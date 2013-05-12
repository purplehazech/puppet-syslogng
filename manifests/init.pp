# == Class: syslogng
#
# The syslog class is used to install install syslog-ng.
#
# === Parameters
# [*ensure*]
#  main module switch used to enable or disable installation and configuration
#  of syslog-ng package.
#
class syslogng ($ensure = present) {
  validate_re($ensure, [ '^present', '^absent' ])

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
    [
      '/etc/syslog-ng/syslog-ng.conf',
      '/etc/syslog-ng/scl.conf',
      '/etc/syslog-ng/modules.conf',
    ]:
      ensure => $ensure_file,
      source => [
        'puppet:///modules/syslogng/scl/syslog-ng.conf',
        'puppet:///modules/syslogng/scl/scl.conf',
        'puppet:///modules/syslogng/scl/modules.conf',
      ];
    [
      '/etc/syslog-ng/patterndb.d',
      '/etc/syslog-ng/syslog-ng.conf.d',
      '/etc/syslog-ng/syslog-ng.conf.d/destination.d',
      '/etc/syslog-ng/syslog-ng.conf.d/filter.d',
      '/etc/syslog-ng/syslog-ng.conf.d/source.d',
      '/etc/syslog-ng/syslog-ng.conf.d/log.d',
      '/etc/syslog-ng/syslog-ng.conf.d/option.d',
      '/etc/syslog-ng/syslog-ng.conf.d/service.d',
    ]:
      ensure => $ensure_directory;
  } ~> service { 'syslog-ng':
    ensure => $ensure_service,
    enable => $enable_service,
  }
}
