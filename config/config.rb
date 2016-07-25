require 'yaml'
require 'erb'

module Template
  module Config

    PROJECT_ROOT=File.expand_path(File.dirname(__FILE__) + '/../')

    def self.included(base)
      base.extend(self)
    end

    def config
      @settings ||= YAML.load(ERB.new(File.read(config_file)).result)
    end

    private

    def config_file
      "#{PROJECT_ROOT}/config/config.yml"
    end
  end
end
