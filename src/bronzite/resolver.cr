require "http"
require "uri"
require "./utils/xml_document"

module Bronzite
  class Resolver
    @document = nil.as(Bronzite::Utils::XMLDocument?)

    def initialize(@uri : String, @base_uri : String? = nil)
    end

    getter :document
    getter :uri

    def resolve
      uri = URI.parse(@uri)
      case uri.scheme
      when "http", "https"
        return load_remote(uri)
      when nil
        if @base_uri
          path = File.join([@base_uri.to_s, @uri])
          uri = URI.parse(path)
          case uri.scheme
          when "http", "https"
            return load_remote(uri)
          when nil
            return load_local(path)
          end
        end
        return load_local(@uri)
      end
      raise "Could not parse Uri"
    end

    private def load_remote(uri)
      response = HTTP::Client.get(uri)
      if !response.success?
        raise "Could not fetch remote Wsdl document #{uri}"
      end
      @document = Bronzite::Utils::XMLDocument.new(response.body, File.dirname(uri.path.to_s))
    end

    private def load_local(path)
      if !File.exists?(path)
        raise "Could not fetch local Wsdl document #{path}"
      end
      @document = Bronzite::Utils::XMLDocument.new(File.read(path), File.dirname(path))
    end
  end
end
