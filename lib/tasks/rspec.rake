require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:specs) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color --format d']
  spec.rspec_opts = ['-f JUnit -o results.xml'] if ENV['BAMBOO_CI']
end
