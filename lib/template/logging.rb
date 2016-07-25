require 'logger'

module Template
  module Logging

    def self.included(base)
      base.extend(self)
    end

    def logger
      @@logger ||= begin
        FileUtils.mkdir_p(log_file_location)
        logger = Logger.new(log_file_path)
        logger.level = Logger::DEBUG
        logger
      end
    end

    private

    def log_file_path
      File.join(log_file_location, log_file_name)
    end

    def log_file_name
      'template.log'
    end

    def log_file_location
      ENV['ENV_LABEL'] =~ /prod/ ? '/var/log/template/' : File.absolute_path(File.join(File.dirname(__FILE__), '..', '..', 'log'))
    end
  end
end