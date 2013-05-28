# == Define: syslogng::destination
#
# Create a syslog-ng destination. This facility is used by the main syslogng
# class to create destinations.
#
# === Parameters
#
# [*ensure*]
#  create or remove a destination, may be present or absent. Default: present
# [*conf_dir*]
#  configuration parent dir. Default: /etc/syslog-ng
# [*type*]
#  type of destination to create, currently file and syslog are supported.
#  Default: file

define syslogng::destination (
  $ensure   = present,
  $conf_dir = '/etc/syslog-ng',
  $type     = file,
  $logpaths = {},
  # options below this are for compat with other modules
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
