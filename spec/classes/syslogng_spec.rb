require 'spec_helper'

describe 'syslogng' do
  subject do
    # This makes sure the function is loaded within each test
    function_name = Puppet::Parser::Functions.function(:validate_re)
    scope.method(function_name)
  end
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
      expect { subject.call ['invalid'] }.to raise_error Puppet::Error
    }
  end
end
