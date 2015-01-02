## 0.6.0 - FreeBSD support

* add default source for FreeBSD (issue #8)

## 0.5.0 - syslog-ng 3.4 Bump

* bump required syslog-ng version to 3.4
* add the following logpaths:
    * bluetoothd
    * dbus
    * haveged
    * laptop-mode
    * lightdm
    * NetworkManager
    * polkitd
    * snmptrapd
    * smartd
    * sst-firewall
    * SuSEfirewall2
    * tor
    * ucarp-hook
    * uwsgi
* drop experimental ``rspec-hiera-puppet`` support
* fixed travis config so build matrix shows all supported puppet versions

## 0.4.0 - syslog-ng 3.4 Preparation Release

* update README to reflect that we will be moving to syslog-ng 3.4 in the next Release
* fix Gemfile for current bundler

## 0.3.0 - Config Purging Release

* adds support for purging the config directory using the ``purge_conf_dir`` parameter (#6).

## 0.2.0 - Logpath Release

* adds the following logpaths:
    * anacron
    * dhclient
    * libvirt-hook
    * nslcd
    * yum

## 0.1.1 - Patch Release

* contained some small critical bugfixes

## 0.1.0 - Initial Release
Early release of the syslogng puppet 3 module.

* basic support for installing the syslog-ng package
* support for enabling and ensuring the syslog-ng service
* drop in logpaths for common programs
* configurable `syslog()` destination support

