require 'spec_helper'

describe 'syslogng::service' do
  context "callable with params" do
    let(:title) { 'syslog-ng' }
    let(:params) do
      {
        :ensure => 'present',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog-ng.conf").with(
        {
          :ensure => 'file',
          :source => 'puppet:///modules/syslogng/scl/syslog-ng.conf.d/destination.d/syslog-ng.conf'
        }
      )
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/filter.d/syslog-ng.conf").with(
        {
          :ensure => 'file',
          :source => 'puppet:///modules/syslogng/scl/syslog-ng.conf.d/filter.d/syslog-ng.conf'
        }
      )
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/log.d/90_syslog-ng.conf").with(
        {
          :ensure => 'file',
          :source => 'puppet:///modules/syslogng/scl/syslog-ng.conf.d/log.d/90_syslog-ng.conf'
        }
      )
    }
  end
  context "removeable" do
    let(:title) { 'syslog-ng' }
    let(:params) do
      {
        :ensure => 'absent',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog-ng.conf").with({:ensure => 'absent'})
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/filter.d/syslog-ng.conf").with({:ensure => 'absent'})
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/log.d/90_syslog-ng.conf").with({:ensure => 'absent'})
    }
  end
end
