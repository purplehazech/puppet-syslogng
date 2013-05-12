require 'spec_helper'

describe 'syslogng' do
  context "callable with params" do
    let(:params) do
      {
        :ensure => 'present',
      }
    end
  end
  context "will install package" do
    let(:params) do
      {
        :ensure => 'present'
      }
    end
    it {
      should contain_package('syslog-ng').with({:ensure => 'present'})
    }
  end
  context "will fail on invalid ensure parameter" do
    let (:params) do
      {
        :ensure => 'invalid'
      }
    end
    it {
      expect { should contain_class('syslogng') }.to raise_error Puppet::Error
    }
  end
  context "will remove package" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end
    it {
      should contain_package('syslog-ng').with({:ensure => 'absent'})
    }
  end
  context "will manage syslog-ng conf files" do
    let(:params) do
      {
        :ensure => 'present'
      }
    end
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf').with({:ensure => 'file'})
      should contain_file('/etc/syslog-ng/scl.conf').with({:ensure => 'file'})
      should contain_file('/etc/syslog-ng/modules.conf').with({:ensure => 'file'})
    }
  end
  context "uninstall config files" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/scl.conf').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/modules.conf').with({:ensure => 'absent'})
    }
  end
  context "check for config dirs" do
    it {
      should contain_file('/etc/syslog-ng/patterndb.d').with({:ensure => 'directory'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d').with({:ensure => 'directory'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/destination.d').with({:ensure => 'directory'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/filter.d').with({:ensure => 'directory'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/source.d').with({:ensure => 'directory'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/log.d').with({:ensure => 'directory'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d').with({:ensure => 'directory'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/service.d').with({:ensure => 'directory'})
    }
  end
  context "remove config dirs" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end
    it {
      should contain_file('/etc/syslog-ng/patterndb.d').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/destination.d').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/filter.d').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/source.d').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/log.d').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d').with({:ensure => 'absent'})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/service.d').with({:ensure => 'absent'})
    }
  end
  context "start and ensure service" do
    it {
      should contain_service('syslog-ng').with({:ensure => 'running', :enable => 'true'})
    }
  end
  context "stop service completely" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end
    it {
      should contain_service('syslog-ng').with({:ensure => 'stopped', :enable => false})
    }
  end
  context "configurable base dir" do
    let(:params) do
      {
        :ensure => 'present',
        :conf_dir => '/my/conf/dir'
      }
    end
    it {
      should contain_file('/my/conf/dir/syslog-ng.conf').with_content(/^.*\/my\/conf\/dir.*$/)
      should contain_file('/my/conf/dir/scl.conf')
      should contain_file('/my/conf/dir/modules.conf')
      should contain_file('/my/conf/dir/patterndb.d')
      should contain_file('/my/conf/dir/syslog-ng.conf.d')
      should contain_file('/my/conf/dir/syslog-ng.conf.d/destination.d')
      should contain_file('/my/conf/dir/syslog-ng.conf.d/filter.d')
      should contain_file('/my/conf/dir/syslog-ng.conf.d/source.d')
      should contain_file('/my/conf/dir/syslog-ng.conf.d/log.d')
      should contain_file('/my/conf/dir/syslog-ng.conf.d/option.d')
      should contain_file('/my/conf/dir/syslog-ng.conf.d/service.d')
    }
  end
  context "check for invalid conf dirs" do
    let(:params) do
      {
        :conf_dir => 'Hello World!'
      }
    end
    it {
      expect { should contain_class('syslogng') }.to raise_error Puppet::Error, /is not an absolute path/
    }
  end
end
