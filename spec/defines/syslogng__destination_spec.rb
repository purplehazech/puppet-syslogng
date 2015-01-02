require 'spec_helper'

describe 'syslogng::destination' do
  ['messages', 'radius', 'console', 'kernel', 'puppet-agent'].each do |sut|
    context "callable with params" do
      let(:title) { sut }
      let(:params) do
        {
          :ensure => 'present',
        }
      end
      it {
        should contain_syslogng__destination(sut)
        should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/#{sut}.conf").with(
          {
            :ensure => 'file',
            :source => "puppet:///modules/syslogng/scl/syslog-ng.conf.d/destination.d/#{sut}.conf"
          }
        )
      }
    end
  end
  context "removeable" do
    let(:title) { 'messages' }
    let(:params) do
      {
        :ensure => 'absent',
      }
    end
    it {
      should contain_file("/etc/syslog-ng/syslog-ng.conf.d/destination.d/messages.conf").with({:ensure => 'absent'})
    }
  end
end
