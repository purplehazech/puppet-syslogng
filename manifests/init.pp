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
# [*chain_hostnames*]
#  Enable or disable the chained hostname format. Default: false
# [*flush_lines*]
#  Specifies how many lines are flushed to a destination at a time. Default: 0 
# [*log_fifo_size*]
#  The number of entries in the output fifo.
# [*stats_freq*]
#  The period between two STATS messages in seconds.
#
class syslogng (
  $ensure          = present,
  $conf_dir        = '/etc/syslog-ng',
  $chain_hostnames = false,
  $flush_lines     = 0,
  $log_fifo_size   = 1000,
  $stats_freq      = 43200
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)
  validate_bool($chain_hostnames)
  validate_re($flush_lines, '^[0-9]+$')
  validate_re($log_fifo_size, '^[0-9]+$')
  validate_re($stats_freq, '^[0-9]+$')

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
  $real_chain_hostnames = $chain_hostnames ? {
    true    => 'yes',
    default => 'no'
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
    [
      "${conf_dir}/syslog-ng.conf.d/option.d/default.conf",
    ]:
      ensure  => $ensure_file,
      content => [
        template('syslogng/syslog-ng.conf.d/option.d/default.conf.erb')
      ];
  } ~> service { 'syslog-ng':
    ensure => $ensure_service,
    enable => $enable_service,
  }
}
