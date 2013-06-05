## puppet syslogng

[![Build Status](https://travis-ci.org/purplehazech/puppet-syslogng.png?branch=master)](https://travis-ci.org/purplehazech/puppet-syslogng)

This repository will eventually contain a complete syslog-ng setup.

The idea is to use the rather complete scl configuration in the stepping-stone
[syslog-ng](https://github.com/stepping-stone/syslog-ng) repo as a starting point and adding
templates as I go.

For the scope of this module I am defining completeness as follows:

- manage installation of syslog-ng package (done)
- built in support for a lot of logs (done)
- manage source/destination setup with storeconfigs (syslog destination implemented, needs source and storeconfig setup)
- good documentation (wip)

### Usage

For a simple solution just include the module. This mostly just install a bare
syslog-ng configuration.

```puppet
  class { 'syslogng': }
```

Let's say you need to monitor some logpaths. You can use the create_resources api
to specify the logpaths you need. Services usually consist of a log entry and its
needed filters and destinations.

```puppet
  class { 'syslogng':
    logpaths => {
      'syslog-ng' => {},
      'radius' => {},
    },
  }
```

If you remove a logpath you need to do so manually.

```puppet
  class { 'syslogng':
    logpaths => {
      'syslog-ng' => {},
      'radius' => {
        ensure => absent,
      },
    },
  }
```

If you want to show off all the logpaths, you would do that like so.

```puppet
  class { 'syslogng':
    logpaths => {
      'syslog-ng' => {},
      'acpid' => {},
      'amavis' => {},
      'atftpd' => {},
      'authdaemond' => {},
      'clamd' => {},
      'crond' => {},
      'dhcpcd' => {},
      'dhcpd' => {},
      'dovecot' => {},
      'fc-brokerd' => {},
      'freshclam' => {},
      'imapd' => {},
      'libvirtd' => {},
      'mod_php' => {},
      'msmtp' => {},
      'ntpd' => {},
      'pdns' => {},
      'pdns_recursor' => {},
      'pop3d' => {},
      'portage' => {},
      'postfix' => {},
      'postgres' => {},
      'provisioning' => {},
      'puppet-agent' => {},
      'puppet-master' => {},
      'pure-ftpd' => {},
      'racoon' => {},
      'radiusd' => {},
      'rsnapshot' => {},
      'saslauthd' => {},
      'slapd' => {},
      'sshd' => {},
      'ssmtp' => {},
      'stunnel' => {},
      'sudo' => {},
      'ucarp' => {},
      'ulogd' => {},
      'vm-manager' => {},
      'zabbix-agentd' => {},
      'zabbix-proxy' => {},
    }
  }
```

There is no way to include all the available logpaths automatically. It was a
conscious design decision not to implement that.

The proper way to do all this would be from an external node classifier. A smart api
for module developers who would like to integrate with this module is in the works.

### Advanced Examples

#### Log to multiple remote destinations via the syslog protocol.

Note that the destinations and their logpaths need unique names. For the destinations
the name is also the hostname or ip of the remote syslog server.

```puppet
  class { 'syslogng':
    ensure => present,
    logpaths => {
     'syslog-ng' => {}
    },
    destinations => {
      'remote-host-a.example.com' => {
        type => 'syslog',
        logpaths => {
          'syslog-ng-a' => {
            logpath => 'syslog-ng'
          }
        }
      }
      'remote-host-b.example.com' => {
        type => 'syslog',
        logpaths => {
          'syslog-ng-b' => {
            logpath => 'syslog-ng'
          }
        }
      }
    }
  }
```

With this setup Messages going the syslog-ng logpath will be logged to both servers as
well as to the local file system.

### Developers

Pull Requests, Issues and other Feedback are very welcome!

Please submit proper pull requests and be prepared to get nagged if you don't write spec
first. Travis will run the tests for you and indicate their results in the pull request.
Please split your pull requests into multiple commits and demonstrate failing spec early.

I happily accept pull requests containing only spec and/or docs. If you found some exotic
use case that work nicely on your infrastructure please consider documenting it in a spec
case so future updates of this module don't introduce breakage.

The following commands come in handy when hacking this module.

```sh
  rake lint
  rake spec
```

### License

2012, Lucas S. Bickel, Alle Rechte vorbehalten

This program is free software: you can redistribute it and/or modify it under the terms
of the GNU Affero General Public License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this
program. If not, see [www.gnu.org/licenses/](http://www.gnu.org/licenses/).
