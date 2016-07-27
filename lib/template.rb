require_relative '../lib/template/service_provider'

Dir[File.join(File.dirname(__FILE__), '**/*.rb')].each { |file| require file }

module Template
  include Logging

  def self.run
    logger.info("Starting run...")

    items = []
    begin
      items = ServiceProvider.new.run
    rescue ServiceProvider::RequestError, ServiceProvider::UnexpectedResponse, ServiceProvider::InvalidJSON => e
      logger.error("Unexpected error \n#{e.message}")
      return false
    end

    logger.info("Finished: Response is #{items}")

    items
  end
end
