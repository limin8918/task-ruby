require 'httparty'
require 'tempfile'
require_relative '../../config/config'
require_relative 'logging'

module Template
  class ServiceProvider

    include Logging
    include Config
    include HTTParty

    base_uri config[:service_url]

    class RequestError < StandardError; end
    class UnexpectedResponse < StandardError; end
    class InvalidJSON < StandardError; end

    def run
      json_file = get_test_json

      parse_test_json(json_file)
    end

    private

    def get_test_json
      begin
        response = self.class.get('/test',:timeout => 5, headers: {'Accept' => 'application/json'})
      rescue => e
        raise RequestError.new("Failed to fetch test json: #{e.message}, #{e.backtrace}")
      end

      unless response.code == 200
        raise UnexpectedResponse.new("expected 200 response code from #{self.class.base_uri}/test, got #{response.code}")
      end

      save_locally(response.body, 'snapshot.json')
    end

    def save_locally(content, filename)
      file = Tempfile.new(filename)
      logger.info("Saving #{file.path} to temp file...")
      file.puts(content)
      file.close
      file
    end

    def parse_test_json test_file
      logger.info 'Processing json retrieved from test'
      items = []
      begin
        parser = JsonStreamParser.new
        parser.parse_json_file_at_depth(test_file, 2) do |item|
          items << {
              id: item['id'].to_s.strip.to_i,
              name: item['name'].strip
          }
        end
      rescue
        raise InvalidJSON.new("Failed to parse the test json")
      end
      logger.info "Finished processing items. Items created: #{items.size}"

      if items.empty?
        raise InvalidJSON.new("Failed to parse the test json")
      end

      items
    end
  end
end