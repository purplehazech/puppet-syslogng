# == Define: syslogng::destination
#
# Create a default file based syslog-ng destination.
#
# This define is used to create parts of the default non parameterized setup.
#
# === Parameters
#
# [*ensure*]
#  Create or remove a destination, may be present or absent.
#  Default: present
# [*conf_dir*]
#  configuration parent dir.
#  Default: /etc/syslog-ng
# [*type*]
#  Type of destination to create must be file.
# [*...*]
#  Remaining parameters are not used by this module but are replicated here to
#  support an api that is designed looking ahead at the nice filter features in
#  puppet 3.2.
#
define syslogng::destination (
  $ensure   = present,
  $conf_dir = '/etc/syslog-ng',
  $type     = file,
  # options below this are for compat with other modules
  $logpaths        = undef,
  $priority        = undef,
  $transport       = undef,
  $port            = undef,
  $no_multi_line   = undef,
  $flush_lines     = undef,
  $flush_timeout   = undef,
  $frac_digits     = undef,
  $ip_tos          = undef,
  $ip_ttl          = undef,
  $keep_alive      = undef,
  $localip         = undef,
  $localport       = undef,
  $log_fifo_size   = undef,
  $so_broadcast    = undef,
  $so_keepalive    = undef,
  $so_rcvbuf       = undef,
  $so_sndbuf       = undef,
  $spoof_source    = undef,
  $suppress        = undef,
  $template        = undef,
  $template_escape = undef,
  $throttle        = undef,
  $tls             = undef,
) {
  validate_re($ensure, [ '^present', '^absent' ])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure
  }

  case $type {
    file: {
      file { "${conf_dir}/syslog-ng.conf.d/destination.d/${title}.conf":
        ensure => $ensure_file,
        source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/destination.d/${title}.conf"
      }
    }
    default:{
      # noop
    }
  }
}
