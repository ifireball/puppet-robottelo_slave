require 'spec_helper'

describe 'robottelo_slave' do

 context 'on redhat' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.4',
        :operatingsystemmajrelease => '6.4',
        :osreleasemajor            => '6',
        :osfamily                  => 'RedHat',
        :processorcount            => 3,
      }
    end

    it { should contain_class('robottelo_slave::install') }
    it { should contain_class('robottelo_slave::config') }
  end

end
