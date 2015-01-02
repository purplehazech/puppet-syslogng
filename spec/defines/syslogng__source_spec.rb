require 'spec_helper'

describe 'syslogng::source' do
  context "callable with params" do
    let(:title) { 'default' }
    let(:params) do
      {
        :ensure => 'present',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/source.d/default.conf").with(
        {
	  :ensure => 'file',
	  :source => 'puppet:///modules/syslogng/scl/syslog-ng.conf.d/source.d/default.conf'
	}
      )
    }
  end
  context "removeable" do
    let(:title) { 'default' }
    let(:params) do
      {
	:ensure => 'absent',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/source.d/default.conf").with({:ensure => 'absent'})
    }
  end
  context "default source on FreeBSD" do
    let(:title) { 'default' }
    let(:params) do
      {
        :ensure => 'present',
      }
    end
    let(:facts) do
      {
        :osfamily => 'FreeBSD',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/source.d/default.conf").with(
        {
	  :ensure => 'file',
	  :source => 'puppet:///modules/syslogng/source.d/default_freebsd.conf'
	}
      )
    }
  end
  context "source source on FreeBSD" do
    let(:title) { 'kernel' }
    let(:params) do
      {
        :ensure => 'present',
      }
    end
    let(:facts) do
      {
        :osfamily => 'FreeBSD',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/source.d/kernel.conf").with(
        {
	  :ensure => 'file',
	  :source => 'puppet:///modules/syslogng/scl/syslog-ng.conf.d/source.d/kernel.conf'
	}
      )
    }
  end
end
