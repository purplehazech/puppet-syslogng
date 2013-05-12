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

  package { 'syslog-ng':
    ensure => $ensure
  }
}
