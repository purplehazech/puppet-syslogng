# == Define: syslogng::destination::syslog
#
#
define syslogng::destination::syslog (
  $ensure          = present,
  $conf_dir        = '/etc/syslog-ng',
  $services        = {
    'syslog-ng' => {},
  },
  $priority        = 00,
  $transport       = 'tcp',
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
) {
  validate_re($ensure, ['^present$', '^absent$'])
  validate_absolute_path($conf_dir)
  validate_re($transport, ['^tcp$', '^udp$', '^tls$'])

  $ensure_file = $ensure ? {
    present => file,
    default => $ensure,
  }

  $real_port = $port ? {
    undef   => $transport ? {
      'udp'   => 514,
      'tls'   => 6514,
      default => 601,
    },
    default => $port,
  }

  $template_base = 'syslogng/syslog-ng.conf.d'
  file { "${conf_dir}/syslog-ng.conf.d/destination.d/syslog_${title}.conf":
    ensure  => $ensure_file,
    content => template("${template_base}/destination.d/syslog.conf.erb")
  }

  create_resources(syslogng::destination::syslog::service, $services, {
    ensure   => $ensure,
    conf_dir => $conf_dir,
    priority => $priority,
    destination => $title,
  })

}
