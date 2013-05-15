require 'spec_helper'

describe 'syslogng::destination::syslog' do
  context "callable with params" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do
      {
        :ensure   => 'present',
	:services => {
	  'syslog-ng' => {},
	},
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with(
        {
	  :ensure  => 'file',
	  :content => /^destination d_syslog_remote-server-hostname.*$/,
	}
      )
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/service.d/00_syslog_syslog-ng.conf").with(
        {
	  :ensure  => 'file',
	  :content => /^log \{ source\(s_log\); filter\(f_syslog-ng\); destination\(d_syslog_remote-server-hostname\); \};/,
	}
      )
    }
  end
end
