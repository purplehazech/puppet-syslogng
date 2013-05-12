require 'spec_helper'

describe 'syslogng' do
  context "callable with params" do
    let(:params) do
      {
        :ensure => 'undef',
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
end
