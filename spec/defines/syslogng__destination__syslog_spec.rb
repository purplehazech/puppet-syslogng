require 'spec_helper'

describe 'syslogng::destination::syslog' do
  context "sensible default" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do
      {
        :ensure   => 'present',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with(
        {
          :ensure  => 'file',
          :content => /.*destination d_syslog_remote-server-hostname.*.*transport\("tcp"\).*/m,
        }
      )
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/log.d/00_syslog_syslog-ng.conf").with(
        {
          :ensure  => 'file',
          :content => /^.*log \{ source\(s_log\); filter\(f_syslog-ng\); destination\(d_syslog_remote-server-hostname\); \};.*/,
        }
      )
    }
  end
  context "priority configurable" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do
      {
        :priority => 20,
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/log.d/20_syslog_syslog-ng.conf")
    }
  end
  context "hostname in conf file" do
    let(:title) { 'remote-server-hostname' }
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with(
        {
	  :content => /^.*syslog\( "remote-server-hostname".*$/
	}
      )
    }
  end
  context "support udp transport" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do 
      {
        :transport => 'udp'
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with(
        {
	  :content => /.*transport\("udp"\).*port\(514\).*/m
	}
      )
    }
  end
  context "support tls transport" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do 
      {
        :transport => 'tls'
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with(
        {
	  :content => /.*transport\("tls"\).*port\(6514\).*/m
	}
      )
    }
  end
  context "fail invalid transport" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do 
      {
        :transport => 'ppp'
      }
    end
    it {
      expect { should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf") }.to raise_error Puppet::Error
    }
  end
  context "default tcp port" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do
      {
        :transport => 'tcp'
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with_content(
        /^.*port\(601\).*$/
      )
    }
  end
end
