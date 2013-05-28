# == Define: syslogng::logpath
#
# Create a syslog-ng logpath configuration. This define takes care of
# installing a bundled logpath definition consisting of a filter, log
# and destination configuration for a given program or logpath.
#
# Use these if you are happy with the bundled setups available for the
# fastest configuration possibility. If you need more flexibility you
# will probably want to start replacing some modules from the bundle
# with dedicated syslogng::source, syslogng::destination and other
# resources.
#
# As long as you are happy to keep the default file logs in /var/log
# you should be able to add quite some logpaths before that while
# still benefiting from the defaults.
#
# === Parameters
#
# [*ensure*]
#  create or remove logpath, may be present or absent. Default: present
# [*conf_dir*]
#  configurations parent dir. Default: /etc/syslog-ng
#
# === Examples
#
# Though this class is usually called through the create_resources api
# on the main syslogng class, you may still invoke it directly like so:
#
#   syslogng::logpath { 'syslog-ng':
#     ensure => present,
#   }
#
define syslogng::logpath (
  $ensure   = present,
  $conf_dir = '/etc/syslog-ng'
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  file {
    "${conf_dir}/syslog-ng.conf.d/destination.d/${title}.conf":
      ensure => $ensure_file,
      source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/destination.d/${title}.conf";
    "${conf_dir}/syslog-ng.conf.d/filter.d/${title}.conf":
      ensure => $ensure_file,
      source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/filter.d/${title}.conf";
    "${conf_dir}/syslog-ng.conf.d/log.d/90_${title}.conf":
      ensure => $ensure_file,
      source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/log.d/90_${title}.conf";
  }
}
