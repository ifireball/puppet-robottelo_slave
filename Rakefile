# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

# blacksmith isn't always present, e.g. on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
  Blacksmith::RakeTask.new do |t|
    t.tag_pattern = "%s"
  end
rescue LoadError
end

PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "vendor/**/*.pp"]
PuppetLint.configuration.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'

task :puppetfile_fixtures do
  if !File.exist?('spec/fixtures')
    `librarian-puppet install --path spec/fixtures/modules`
    `git clone --recursive https://github.com/theforeman/foreman-infra .foreman-infra`
    `cp -rf .foreman-infra/puppet/modules/* spec/fixtures/modules`
    `rm -rf .foreman-infra`

    Dir.chdir('spec/fixtures/modules') do
      `ln -s ../../../ robottelo_slave`
    end
  end
end

Rake::Task[:spec].enhance [:puppetfile_fixtures]

task :default => [:validate, :lint, :spec]
