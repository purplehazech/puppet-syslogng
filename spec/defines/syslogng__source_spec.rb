require 'spec_helper'

describe 'syslogng::source' do
  context "callable with params" do
    let(:title) { 'messages' }
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
    let(:title) { 'messages' }
    let(:params) do
      {
	:ensure => 'absent',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/source.d/messages.conf").with({:ensure => 'absent'})
    }
  end
end
