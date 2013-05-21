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
          :content => /^.*destination d_syslog_remote-server-hostname.*$/,
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
end
