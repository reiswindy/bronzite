require "http"
require "uri"

module Bronzite
  class Resolver
    @document = ""

    def initialize(@uri : String)
    end

    getter document
    getter uri

    def resolve
      uri = URI.parse(@uri)
      case scheme = uri.scheme
      when "http", "https"
        return load_remote
      when "file"
        return load_local(uri.path.to_s)
      end
      raise "Could not parse Uri"
    end

    private def load_remote
      response = HTTP::Client.get(@uri)
      if !response.success?
        raise "Could not fetch remote Wsdl document #{@uri}"
      end
      @document = response.body
    end

    private def load_local(path)
      if !File.exists?(path)
        raise "Could not fetch local Wsdl document #{path}"
      end
      @document = File.read(path)
    end
  end
end
