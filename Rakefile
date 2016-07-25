require 'rubygems'
require 'bundler'
require_relative 'lib/template'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

task default: ["specs"]

FileList['./lib/tasks/**/*.rake'].each { |task| load task } unless ENV['ENV_LABEL'] == 'prod'

desc 'template to run'
task :run do
  Template.run
end
