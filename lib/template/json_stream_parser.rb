require 'json/stream'

module Template

    class JsonStreamParser

      def parse_json_file_at_depth(file, interesting_depth, &block)
        parser = create_parser(interesting_depth, &block)

        buffer = ""
        stream = File.open(file.path, "r+")
        while stream.read(256, buffer)
          parser << buffer
        end
        stream.close
      end

      private
      def create_parser(interesting_depth, &block)
        parse_context = { keys: [], objects: [], interesting_depth: interesting_depth }
        parser = JSON::Stream::Parser.new

        set_start_object(parser, parse_context)

        set_end_object(parser, parse_context, &block)

        set_key(parser, parse_context)

        set_value(parser, parse_context)

        parser
      end

      def set_start_object(parser, parse_context)
        parser.start_object do
          parse_context[:objects].push Hash.new
        end
      end

      def set_end_object(parser, parse_context, &block)
        objects = parse_context[:objects]
        keys = parse_context[:keys]
        interesting_depth = parse_context[:interesting_depth]

        parser.end_object do
          depth = objects.size
          object = objects.pop

          if depth > interesting_depth
            objects.last[keys.pop] = object
          elsif depth == interesting_depth
            yield object
          end
        end
      end

      def set_key(parser, parse_context)
        parser.key do |k|
          parse_context[:keys].push k
        end
      end

      def set_value(parser, parse_context)
        parser.value do |v|
          parse_context[:objects].last[parse_context[:keys].pop] = v
        end
      end
    end
  end
