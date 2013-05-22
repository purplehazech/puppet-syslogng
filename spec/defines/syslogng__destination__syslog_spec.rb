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
  context "a heap of additional optional params" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do
      {
        :port            => 123,
	:no_multi_line   => true,
	:flush_lines     => 10,
	:flush_timeout   => 20,
	:frac_digits     => 5,
	:ip_tos          => 11,
	:ip_ttl          => 1,
	:keep_alive      => false,
	:localip         => "1.1.1.1",
	:localport       => 1234,
	:log_fifo_size   => 128,
	:so_broadcast    => true,
	:so_keepalive    => true,
	:so_rcvbuf       => 256,
	:so_sndbuf       => 1024,
	:spoof_source    => true,
	:suppress        => 12,
	:template        => "my-template",
	:template_escape => true,
	:throttle        => 13,
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with_content(
        /.*port\(123\).*flags\(no-multi-line\).*flush_lines\(10\).*flush_timeout\(20\).*frac_digits\(5\).*ip_tos\(11\).*ip_ttl\(1\).*keep-alive\(no\).*localip\("1.1.1.1"\).*localport\(1234\).*log_fifo_size\(128\).*so_broadcast\(yes\).*so_keepalive\(yes\).*so_rcvbuf\(256\).*so_sndbuf\(1024\).*spoof_source\(yes\).*suppress\(12\).*template\("my-template"\).*template_escape\(yes\).*throttle\(13\).*/m
      )
    }
  end
  context "complete tls configuration" do
    let(:title) { 'remote-server-hostname' }
    let(:params) do
      {
        :transport => 'tls',
	:tls       => {
	  "ca_dir"       => "/ca/dir",
	  "cert_file"    => "/cert/dir",
	  "cipher_suite" => "sha",
	  "crl_dir"      => "/crl/dir",
          "key_file"     => "/key/file",
	  "peer_verify"  => "optional-trusted",
	  "trusted_dn"   => "C=CH",
	  "trusted_keys" => [
	    "SHA1:00:EF:ED:A4:CE:00:D1:14:A4:AB:43:00:EF:00:91:85:FF:89:28:8F",
	    "SHA1:0C:42:00:3E:B2:60:36:64:00:E2:83:F0:80:46:AD:00:A8:9D:00:15"
	  ]
	}
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/syslog_remote-server-hostname.conf").with_content(
        /.*transport\("tls"\).*tls\(.*ca_dir\("\/ca\/dir"\).*cert_file\("\/cert\/file"\).*cipher_suite\(sha\).*crl_dir\("\/crl\/dir"\).*key_file\("\/key\/file"\).*peer_verify\(optional-trusted\).*trusted_dn\("C=CH"\).*trusted_keys\("SHA1:00:EF:ED:A4:CE:00:D1:14:A4:AB:43:00:EF:00:91:85:FF:89:28:8F", "SHA1:0C:42:00:3E:B2:60:36:64:00:E2:83:F0:80:46:AD:00:A8:9D:00:15"\).*\).*/m
      )
    }
  end
end
