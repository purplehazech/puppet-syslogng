## puppet syslogng

[![Build Status](https://travis-ci.org/purplehazech/puppet-syslogng.png?branch=master)](https://travis-ci.org/purplehazech/puppet-syslogng)

The syslogng puppet module sets up and manages syslog-ng. This module supports syslog-ng versions > 3.4.

The idea is to use the rather complete scl configuration in the [stepping-stone syslog-ng repo](https://github.com/stepping-stone/syslog-ng) as a basic configuration 
while adding things that need machine specific configuration through puppet templates.

For the scope of this module I am defining completeness as follows:

- manage installation of syslog-ng package (done)
- built in support for a lot of logs (done)
- manage source/destination setup with storeconfigs (syslog destination implemented, needs source and storeconfig setup)
- good documentation (wip)

In the long run the syslogng puppet module aims to be the most complete syslog-ng puppet module
available. Please consider joining the effort to help us get there.

### Usage

For a simple solution just include the syslogng puppet module. This installs syslog-ng
with a bare configuration. Only the syslog-ng and puppet-agent log messages get a
logpath in this configuration.

```puppet
  class { 'syslogng': }
```

Let's say you have some services that need logpaths. You can use the create_resources
api on the main class to specify the logpaths you need. Logpaths usually consist of a
log entry and its needed filters and destinations.

```puppet
  class { 'syslogng':
    logpaths => {
      'syslog-ng' => {},
      'puppet-agent' => {},
      'radius' => {},
    },
  }
```

If you remove a logpath you need to do so manually.

```puppet
  class { 'syslogng':
    logpaths => {
      'syslog-ng' => {},
      'puppet-agent' => {},
      'radius' => {
        ensure => absent,
      },
    },
  }
```

If you want to show off all logpaths available in the syslogng puppet module, you would
do that like so.

```puppet
  class { 'syslogng':
    logpaths => {
      'acpid' => {},
      'amavis' => {},
      'anacron' => {},
      'atftpd' => {},
      'authdaemond' => {},
      'bluetoothd' => {},
      'clamd' => {},
      'crond' => {},
      'dbus' => {},
      'dhclient' => {},
      'dhcpcd' => {},
      'dhcpd' => {},
      'dovecot' => {},
      'fc-brokerd' => {},
      'freshclam' => {},
      'haveged' => {},
      'imapd' => {},
      'laptop-mode' => {},
      'libvirtd' => {},
      'libvirt-hook' => {},
      'lightdm' => {},
      'mod_php' => {},
      'msmtp' => {},
      'NetworkManager' => {},
      'nslcd' => {},
      'ntpd' => {},
      'pdns' => {},
      'pdns_recursor' => {},
      'polkitd' => {},
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
      'snmptrapd' => {},
      'smartd' => {},
      'sshd' => {},
      'ssmtp' => {},
      'sst-firewall' => {},
      'stunnel' => {},
      'sudo' => {},
      'SuSEfirewall2' => {},
      'syslog-ng' => {},
      'tor' => {},
      'ucarp' => {},
      'ucarp-hook' => {},
      'ulogd' => {},
      'uwsgi' => {},
      'vm-manager' => {},
      'yum' => {},
      'zabbix-agentd' => {},
      'zabbix-proxy' => {},
    }
  }
```

There is no way to include all the available logpaths automatically. It was a
conscious design decision not to implement that.

The proper way to do all this would be from an external node classifier.

### Advanced Examples

#### Purge existing configuration

You can set the ``purge_conf_dir`` parameter to ``true`` to remove all existing configs
from the syslog-ng configuration directory.

```puppet
  class { 'syslogng':
    ensure         => present,
    purge_conf_dir => true,
  }
```

#### Log to multiple remote destinations via the syslog protocol.

Note that the destinations and their logpaths need unique names. For the destinations
the name is also the hostname or ip of the remote syslog server.

```puppet
  class { 'syslogng':
    ensure => present,
    logpaths => {
     'syslog-ng' => {},
     'puppet-agent' => {},
    },
    destinations => {
      'remote-host-a.example.com' => {
        type => 'syslog',
        logpaths => {
          'syslog-ng-a' => {
            logpath => 'syslog-ng'
          },
          'puppet-agent-a' => {
            logpath => 'puppet-agent'
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
well as to the local file system. The puppet-agent logpath only goes to the first server
and the local file system.

#### Log to mongodb

Setting up mongodb is similar to using remote syslog-ng destinations.

```puppet
  class { ' syslogng':
    ensure => present,
    logpaths => {
      'syslog-ng' => {},
      'puppet-agent' => {},
    },
    destinations => {
      'mongodb' => {
        'type' => 'mongodb',
        logpaths => {
          'syslog-ng-mongodb' => {
            logpath => 'syslog-ng'
          },
        },
      },
    },
  }
```

### Integrating this module with other puppet modules

Let's say you just puppetized your latest and greatest software and would like to add some
nice logpaths for your thing to the syslogng puppet module.

The right file to do this is README.md, just mention that your module is supported by
the syslogng puppet module. This keeps the logging and your modules concerns uncoupled
and lets the end user decide on a logging solution. Great puppet solutions should be able
to integrate with this on the node level.

You will want to add a nice configuration example to your docs. You might copy the radius
example above and add a link to the syslogng puppet module.

If the syslogng puppet module does not yet have a default logpath for your service please
consider adding one.

* Fork stepping-stone/syslog-ng.
* Create a pull request containing the config you need.
* Fork the syslogng puppet module when your pull request went through.
* While you are waiting for it to be accepted you might write some spec if you will be
  needing any changes to the syslogng puppet module.
* Add a submodule update containing the latest stepping-stone/syslog-ng master to your
  pull request. Don't worry if the commit contains contents not related to your
  particular merge, that is considered ok.
* Wait for review, merging and release.

You can refer to [016ddb1](https://github.com/stepping-stone/syslog-ng/commit/016ddb162a141b773b46582ea72cf9fef696ec79)
and [5e33ec9](https://github.com/purplehazech/puppet-syslogng/commit/5e33ec9623d5fde0d4bd4757267c41bac8277d63)
for some example merges.

### Developers

Pull requests, issues and other feedback are very welcome!

Please submit proper pull requests and be prepared to get nagged if you don't write spec
first. Travis will run the tests for you and indicate their results in the pull request.
Please split your pull requests into multiple commits and demonstrate failing spec early.

I happily accept pull requests containing only spec and/or docs. If you found some exotic
use cases that work nicely on your infrastructure please consider documenting them in 
some spec so future updates of this module don't introduce breakage.

The following commands come in handy when hacking this module.

```sh
  rake lint
  rake spec
```

The main development of this module happens in the [puppet-syslogng github repository](
https://github.com/purplehazech/puppet-syslogng).

If you need to hack this module without source control or in anything except the
official github source, you are strongly encouraged to join the efforts on github by
submitting issues and through pull requests.

This project considers lacking or unclear documentation as bugs.

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
