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
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with({:ensure => 'file'});
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
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with({:ensure => 'absent'});
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
    }
  end
  context "not purge config dirs by default" do
    it {
      should contain_file('/etc/syslog-ng/patterndb.d').with({:purge => false, :force => false, :recurse => false})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d').with({:purge => false, :force => false, :recurse => false})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/destination.d').with({:purge => false, :force => false, :recurse => false})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/filter.d').with({:purge => false, :force => false, :recurse => false})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/source.d').with({:purge => false, :force => false, :recurse => false})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/log.d').with({:purge => false, :force => false, :recurse => false})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d').with({:purge => false, :force => false, :recurse => false})
    }
  end
  context "purge config dirs when asked" do
    let(:params) do
      {
        :purge_conf_dir => true
      }
    end
    it {
      should contain_file('/etc/syslog-ng/patterndb.d').with({:purge => true, :force => true, :recurse => true})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d').with({:purge => true, :force => true, :recurse => true})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/destination.d').with({:purge => true, :force => true, :recurse => true})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/filter.d').with({:purge => true, :force => true, :recurse => true})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/source.d').with({:purge => true, :force => true, :recurse => true})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/log.d').with({:purge => true, :force => true, :recurse => true})
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d').with({:purge => true, :force => true, :recurse => true})
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
  context "check for default options" do
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*options \{.*/);
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*chain_hostnames\(no\);.*/);
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*flush_lines\(0\);.*/);
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*log_fifo_size\(1000\);.*/);
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*stats_freq\(43200\);.*/);
    }
  end
  context "check for hostname chain config" do
    let(:params) do
      {
        :chain_hostnames => true
      }
    end
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*chain_hostnames\(yes\);.*/);
    }
  end
  context "check for flush_lines config" do
    let(:params) do
      {
        :flush_lines => '10'
      }
    end
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*flush_lines\(10\);.*/);
    }
  end
  context "check for log_fifo_size config" do
    let(:params) do
      {
        :log_fifo_size => '100000'
      }
    end
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*log_fifo_size\(100000\);.*/);
    }
  end
  context "check for stats_freq config" do
    let (:params) do
      {
        :stats_freq => '600'
      }
    end
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/option.d/default.conf').with_content(/.*stats_freq\(600\);.*/);
    }
  end
  context "should configure logdir" do
    let (:params) do
      {
        :log_dir => '/my/log/dir'
      }
    end
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf').with_content(/^.*\/my\/log\/dir\/syslog.*$/)
      should contain_file('/my/log/dir/syslog').with({:ensure => 'directory'});
    }
  end
  context "check for default destinations" do
    it {
      should contain_syslogng__destination('messages').with({:ensure => 'present'})
      should contain_syslogng__destination('console').with({:ensure => 'present'})
      should contain_syslogng__destination('kernel').with({:ensure => 'present'})
    }
  end
  context "default facilities" do
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/filter.d/facilities.conf').with(
        {
	  :ensure => 'file',
	  :source => 'puppet:///modules/syslogng/scl/syslog-ng.conf.d/filter.d/facilities.conf'
        }
      )
    }
  end
  context "catch all config" do
    it {
      should contain_file('/etc/syslog-ng/syslog-ng.conf.d/log.d/99_catch-all.conf').with(
        {
	  :ensure => 'file',
	  :source => 'puppet:///modules/syslogng/scl/syslog-ng.conf.d/log.d/99_catch-all.conf'
        }
      )
    }
  end
  context "define sources" do
    it {
      should contain_syslogng__source('default').with({:ensure => 'present'})
      should contain_syslogng__source('kernel').with({:ensure => 'present'})
    }
  end
  context "define syslog-ng logpath" do
    it {
      should contain_syslogng__logpath('syslog-ng').with({:ensure => 'present'})
    }
  end
  context "define puppet-agent logpath" do
    it {
      should contain_syslogng__logpath('puppet-agent').with({:ensure => 'present'})
    }
  end
  context "logpath config from param" do
    let(:params) do
      {
        :logpaths => { "syslog-ng" => {}, "radius" => {} }
      }
    end
    it {
      should contain_syslogng__logpath('syslog-ng').with({:ensure => 'present'})
      should contain_syslogng__logpath('radius').with({:ensure => 'present'})
    }
  end
  context "destination config from param" do
    let(:params) do
      {
        :destinations => { "messages" => {}, "console" => { "ensure" => 'absent' } }
      }
    end
    it {
      should contain_syslogng__destination('messages').with({:ensure => 'present'})
      should contain_syslogng__destination('console').with({:ensure => 'absent'})
    }
  end
  context "sources config from param" do
    let(:params) do
      {
        :sources => { "default" => {}, "kernel" => { "ensure" => 'absent' } }
      }
    end
    it {
      should contain_syslogng__source('default').with({:ensure => 'present'})
      should contain_syslogng__source('kernel').with({:ensure => 'absent'})
    }
  end
  context "syslog destination from destination param via type hint" do
    let(:params) do
      {
        :destinations => { "remote-server-hostname" => { "type" => "syslog" } }
      }
    end
    it {
      should contain_syslogng__destination__syslog('remote-server-hostname')
    }
  end
  context "mongodb destination from destination param via type hint" do
    let(:params) do
      {
        :destinations => { "mongodb-dest-name" => { "type" => "mongodb" } }
      }
    end
    it {
      should contain_syslogng__destination__mongodb('mongodb-dest-name')
    }
  end
end
