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

