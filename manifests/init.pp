# == Class: syslogng
#
# The syslog class is the main entry point for admins that want to take control
# of their syslog-ng infrastructure using puppet.
#
# === Usages
#
# Sources, logpaths and destinations are stored in files/scl/syslog-ng.conf.d.
#
# An example config such files looks like so.
#
#   class { syslogng:
#     ensure        => present,
#
#     sources       => {
#       "default"   => {},
#       "kernel"    => {},
#     },
#     logpaths      => {
#       "syslog-ng" => {},
#       "radius"    => {},
#     },
#     destinations  => {
#       "messages"  => {},
#       "console"   => {},
#       "kernel"    => {},
#     },
#   }
#
# === Parameters
#
# [*ensure*]
#  Main module switch used to enable or disable installation and configuration
#  of syslog-ng package.
# [*conf_dir*]
#  Base directory of syslog-ng config files.
# [*log_dir*]
#  Base directory to log into, this is where a syslog subdir is created.
#  Default: /var/log
# [*sources*]
#  Hash of sources to configure. Default:
#   {
#     'default' => {},
#     'kernel' => {}
#   }
# [*logpaths*]
#  Hash of logpaths to configure.
#  Default:
#    { 'syslog-ng' => {} }
#  See the README for a complete list of logpaths.
# [*destinations*]
#  Hash of log destinations.
#  Default:
#    {
#      'messages' => {},
#      'console'  => {},
#      'kernel'   => {},
#    }
# [*chain_hostnames*]
#  Enable or disable the chained hostname format.
#  Default: false
# [*flush_lines*]
#  Specifies how many lines are flushed to a destination at a time.
#  Default: 0
# [*log_fifo_size*]
#  The number of entries in the output fifo.
# [*stats_freq*]
#  The period between two STATS messages in seconds.
#
class syslogng (
  $ensure          = present,
  $conf_dir        = '/etc/syslog-ng',
  $log_dir         = '/var/log',
  $sources         = {
    'default' => {},
    'kernel'  => {},
  },
  $logpaths        = {
    'syslog-ng' => {},
  },
  $destinations    = {
    'messages' => {},
    'console'  => {},
    'kernel'   => {},
  },
  $chain_hostnames = false,
  $flush_lines     = 0,
  $log_fifo_size   = 1000,
  $stats_freq      = 43200
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)
  validate_absolute_path($log_dir)
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
    default => 'no',
  }
  $confd_path = 'puppet:///modules/syslogng/scl/syslog-ng.conf.d'
  $default_conf = template(
    'syslogng/syslog-ng.conf.d/option.d/default.conf.erb'
  )

  package { 'syslog-ng':
    ensure => $ensure
  } -> file {
    "${conf_dir}/syslog-ng.conf":
      ensure  => $ensure_file,
      content => template('syslogng/syslog-ng.conf.erb');
    "${conf_dir}/scl.conf":
      ensure => $ensure_file,
      source => 'puppet:///modules/syslogng/scl/scl.conf';
    "${conf_dir}/modules.conf":
      ensure => $ensure_file,
      source => 'puppet:///modules/syslogng/scl/modules.conf';
    [
      "${log_dir}/syslog",
      "${conf_dir}/patterndb.d",
      "${conf_dir}/syslog-ng.conf.d",
      "${conf_dir}/syslog-ng.conf.d/destination.d",
      "${conf_dir}/syslog-ng.conf.d/filter.d",
      "${conf_dir}/syslog-ng.conf.d/source.d",
      "${conf_dir}/syslog-ng.conf.d/log.d",
      "${conf_dir}/syslog-ng.conf.d/option.d",
    ]:
      ensure => $ensure_directory;
    "${conf_dir}/syslog-ng.conf.d/option.d/default.conf":
      ensure  => $ensure_file,
      content => $default_conf;
    "${conf_dir}/syslog-ng.conf.d/filter.d/facilities.conf":
      ensure => $ensure_file,
      source => "${confd_path}/filter.d/facilities.conf";
    "${conf_dir}/syslog-ng.conf.d/log.d/99_catch-all.conf":
      ensure => $ensure_file,
      source => "${confd_path}/log.d/99_catch-all.conf";
  } ~> service { 'syslog-ng':
    ensure => $ensure_service,
    enable => $enable_service,
  }

  create_resources(syslogng::source, $sources, {
    ensure   => $ensure,
    conf_dir => $conf_dir,
    notify   => Service['syslog-ng'],
  })

  create_resources(syslogng::logpath, $logpaths, {
    ensure   => $ensure,
    conf_dir => $conf_dir,
    notify   => Service['syslog-ng'],
  })

  $default_destination = {
    ensure   => $ensure,
    conf_dir => $conf_dir,
    notify   => Service['syslog-ng'],
    type     => file,
  }

  create_resources(
    syslogng::destination,
    $destinations,
    $default_destination
  )

  create_resources(
    syslogng::destination::syslog,
    $destinations,
    $default_destination
  )

}
