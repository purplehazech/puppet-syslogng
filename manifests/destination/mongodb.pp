# == Define: syslogng::destination::mongodb
#
# This define exposes an API to configure the mongodb destination
# in almost every way described in the docs.
#
# === Parameters
# [*ensure*]
#  Install or Remove destination, may be present or absent. Default: present
# [*priority*]
#  First part of filename in logpaths created for the destination.
#  Default: priority
# [*conf_dir*]
#  Default: /etc/syslog-ng
# [*...*]
#  Remaining parameters are not used by this module but are replicated here to
#  support an api that is designed looking ahead at the nice filter features in
#  puppet 3.2.
#
define syslogng::destination::mongodb (
  $ensure          = present,
  $logpaths        = {
    'syslog-ng' => {},
  },
  $priority        = 00,
  # options below this are for compat with other modules
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
  $tls             = {},
  $conf_dir        = '/etc/syslog-ng',
  $type            = 'mongodb',
) {
  validate_re($ensure, ['^present$', '^absent$'])
  validate_absolute_path($conf_dir)

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure,
  }

  $template_base = 'syslogng/syslog-ng.conf.d'

  case $type {
    'mongodb': {
      file { "${conf_dir}/syslog-ng.conf.d/destination.d/mongodb_${title}.conf":
        ensure  => $ensure_file,
        content => template("${template_base}/destination.d/mongodb.conf.erb")
      }

      create_resources(syslogng::destination::mongodb::logpath, $logpaths, {
        ensure      => $ensure,
        conf_dir    => $conf_dir,
        priority    => $priority,
        destination => $title,
      })
    }
    default: {
      # noop
    }
  }

}
