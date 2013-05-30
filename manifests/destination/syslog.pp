# == Define: syslogng::destination::syslog
#
# This define exposes a very complete API to configure the syslog destination
# in almost every way described in the docs.
#
# === Parameters
# [*ensure*]
#  Install or Remove destination, may be present or absent. Default: present
# [*priority*]
#  First part of filename in logpaths created for the destination.
#  Default: priority
# [*transport*]
#  Specifies the protocol used to receive messages from the source.
#  Default: transport
# [*port*]
#  The port number to connect to. Note that the default port numbers used by
#  syslog-ng do not comply with the latest RFC which was published after the
#  release of syslog-ng 3.0.2, therefore the default port numbers will change
#  in the future releases.
#  Default: maybe 601, see above
# [*no_multi_line*]
#  The no-multi-line flag disables line-breaking in the messages; the entire
#  message is converted to a single line.
#  Default: false
# [*flush_lines*]
#  Specifies how many lines are flushed to a destination at a time. Syslog-ng
#  waits for this number of lines to accumulate and sends them off in a single
#  batch. Setting this number high increases throughput as fully filled frames
#  are sent to the destination, but also increases message latency. The latency
#  can be limited by the use of the flush_timeout option.
#  Default: Use global setting
# [*frac_digits*]
#  The syslog-ng application can store fractions of a second in the timestamps
#  according to the ISO8601 format.. The frac_digits() parameter specifies the
#  number of digits stored. The digits storing the fractions are padded by zeros
#  if the original timestamp of the message specifies only seconds. Fractions
#  can always be stored for the time the message was received. Note that
#  syslog-ng can add the fractions to non-ISO8601 timestamps as well.
#  Default: 0
# [*ip_tos*]
#  Specifies the Type-of-Service value of outgoing packets.
#  Default: 0
# [*ip_ttl*]
#  Specifies the Time-To-Live value of outgoing packets.
#  Default: 0
# [*keep_alive*]
#  Specifies whether connections to destinations should be closed when syslog-ng
#  is restarted (upon the receipt of a SIGHUP signal). Note that this applies to
#  the client (destination) side of the syslog-ng connections, server-side
#  (source) connections are always reopened after receiving a HUP signal unless
#  the keep-alive option is enabled for the source. When the keep-alive option
#  is enabled, syslog-ng saves the contents of the output queue of the
#  destination when receiving a HUP signal, reducing the risk of losing
#  messages.
#  Default: yes
# [*localip*]
#  The IP address to bind to before connecting to target.
#  Default: 0.0.0.0
# [*localport*]
#  The port number to bind to. Messages are sent from this port.
#  Default: 0
# [*log_fifo_size*]
#  The number of messages that the output queue can store.
#  Default: Use global setting
# [*so_broadcast*]
#  This option controls the SO_BROADCAST socket option required to make
#  syslog-ng send messages to a broadcast address. For details, see the
#  socket(7) manual page.
#  Default: no
# [*so_keepalive*]
#  Enables keep-alive messages, keeping the socket open. This only effects TCP
#  and UNIX-stream sockets. For details, see the socket(7) manual page.
#  Default: no
# [*so_rcvbuf*]
#  Specifies the size of the socket receive buffer in bytes. For details, see
#  the socket(7) manual page.
#  Default: 0
# [*so_sndbuf*]
#  Specifies the size of the socket send buffer in bytes. For details, see the
#  socket(7) manual page.
#  Default: 0
# [*spoof_source*]
#  Enables source address spoofing. This means that the host running syslog-ng
#  generates UDP packets with the source IP address matching the original sender
#  of the message. It is useful when you want to perform some kind of
#  preprocessing via syslog-ng then forward messages to your central log
#  management solution with the source address of the original sender. This
#  option only works for UDP destinations though the original message can be
#  received by TCP as well. This option is only available if syslog-ng was
#  compiled using the --enable-spoof-source configuration option.
#  Default: no
# [*suppress*]
#  If several identical log messages would be sent to the destination without
#  any other messages between the identical messages (for example, an
#  application repeated an error message ten times), syslog-ng can suppress the
#  repeated messages and send the message only once, followed by the Last
#  message repeated n times. message. The parameter of this option specifies the
#  number of seconds syslog-ng waits for identical messages.
#  Default: 0 (disabled)
# [*template*]
#  Specifies a template defining the logformat to be used in the destination.
#  Macros are described in Section 11.1.5, Macros of syslog-ng OSE. Please note
#  that for network destinations it might not be appropriate to change the
#  template as it changes the on-wire format of the syslog protocol which might
#  not be tolerated by stock syslog receivers (like syslogd or syslog-ng
#  itself). For network destinations make sure the receiver can cope with the
#  custom format defined.
#  Default: A format conforming to the default logfile format.
# [*template_escape*]
#  Turns on escaping for the ', ", and backspace characters in templated output
#  files. This is useful for generating SQL statements and quoting string
#  contents so that parts of the log message are not interpreted as commands to
#  the SQL server.
#  Default: no
# [*throttle*]
#  Sets the maximum number of messages sent to the destination per second. Use
#  this output-rate-limiting functionality only when using disk-buffer as well
#  to avoid the risk of losing messages. Specifying 0 or a lower value sets the
#  output limit to unlimited.
#  Default: 0
# [*tls*]
#  This option sets various TLS specific options like key/certificate files and
#  trusted CA locations. TLS can be used only with the tcp transport protocols.
#  @todo For details, see the as of yet unwritten generic tls implementation.
# [*conf_dir*]
#  Default: /etc/syslog-ng
define syslogng::destination::syslog (
  $ensure          = present,
  $logpaths        = {
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
  $conf_dir        = '/etc/syslog-ng',
  $type            = 'syslog',
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

  case $type {
    'syslog': {
      file { "${conf_dir}/syslog-ng.conf.d/destination.d/syslog_${title}.conf":
        ensure  => $ensure_file,
        content => template("${template_base}/destination.d/syslog.conf.erb")
      }

      create_resources(syslogng::destination::syslog::logpath, $logpaths, {
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
