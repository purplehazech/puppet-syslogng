require 'spec_helper'

describe 'syslogng::destination::mongodb' do
  context "sensible default" do
    let(:title) { 'dest-name' }
    let(:params) do
      {
        :ensure   => 'present',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/mongodb_dest-name.conf").with(
        {
          :ensure  => 'file',
          :content => /.*d_mongodb-dest-name.*mongodb.*/m,
        }
      )
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/log.d/00_mongodb_syslog-ng.conf").with(
        {
          :ensure  => 'file',
          :content => /^.*log \{ source\(s_log\); filter\(f_syslog-ng\); destination\(d_mongodb_dest-name\); \};.*/,
        }
      )
    }
  end
  context "priority configurable" do
    let(:title) { 'dest-name' }
    let(:params) do
      {
        :priority => 20,
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/log.d/20_mongodb_syslog-ng.conf")
    }
  end
end
