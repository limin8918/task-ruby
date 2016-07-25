require 'yarjuf'
require 'simplecov'
require 'simplecov-bamboo'
SimpleCov.minimum_coverage 100
SimpleCov.formatter = SimpleCov::Formatter::BambooFormatter
SimpleCov.start do
  add_filter "/logging.rb"
end unless ENV["NO_COVERAGE"]
require 'rspec/its'
require 'find'
require 'ostruct'

ENV["ENV"] = "test"
ENV["ENV_LABEL"] = "test"

def read_fixture filename
  File.read(File.join(File.dirname(__FILE__), 'fixtures', filename))
end

def ignore_stdout
  if ENV["NO_STDOUT"]
    before do
      $stdout.stub(:write)
    end
  end
end

require_relative '../lib/template'
lib_dir = File.join(File.dirname(__FILE__), '..', 'lib','template')

Dir.glob("#{lib_dir}/**/*.rb") do |path|
  if FileTest.file? path
    require path
  end
end
