require 'spec_helper'


describe 'robottelo_slave::config' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
      :operatingsystem            => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6.4',
      :osfamily                   => 'RedHat',
      :processorcount             => 3
    }
  end

  context 'with no parameters' do
    let :pre_condition do
      "class {'robottelo_slave':}"
    end

    let :facts do
      default_facts
    end

    it "should configure robottelo_slave_workers" do
      should contain_git__config('http.sslVerify').with({
        'user'  => 'jenkins',
        'value' => false
      })
    end
  end
end
