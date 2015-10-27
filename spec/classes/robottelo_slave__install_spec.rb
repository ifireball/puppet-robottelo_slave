require 'spec_helper'

describe 'robottelo_slave::install' do
  let :default_facts do
    {
      :concat_basedir             => '/tmp',
      :interfaces                 => '',
      :operatingsystem            => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6.4',
      :osfamily                   => 'RedHat',
      :fqdn                       => 'robottelo_slave.compony.net',
      :hostname                   => 'robottelo_slave',
    }
  end

  describe "with parent" do
    let :facts do
      default_facts
    end

    it { should contain_package('python-devel').with_ensure('present') }
    it { should contain_package('python-pip').with_ensure('present') }
    it { should contain_package('python-virtualenv').with_ensure('present') }
  end
end
