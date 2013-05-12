# == Class: syslogng
#
# The syslog class is used to install install syslog-ng.
#
class syslogng ($ensure = present) {
  validate_re($ensure, [ '^present', '^absent' ])

  package { 'syslog-ng':
    ensure => $ensure
  }
}
