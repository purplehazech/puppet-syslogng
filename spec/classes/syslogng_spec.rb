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
  context "start and ensure service" do
    it {
      should contain_service('syslog-ng').with({:ensure => 'running', :enable => 'true'})
    }
  end
end
