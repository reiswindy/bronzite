require "http"
require "uri"
require "xml"
require "./core_ext/xml"

module Bronzite
  class Resolver

    def resolve(uri_string : String)
      uri = URI.parse(uri_string)
      case uri.scheme
      when "http", "https"
        return load_remote(uri)
      when nil
        return load_local(uri_string)
      else
        raise "Could not parse Uri"
      end
    end

    private def load_remote(uri)
      response = HTTP::Client.get(uri)
      if !response.success?
        raise "Could not fetch remote Wsdl document #{uri}"
      end
      xml_doc = XML.parse(response.body)
      xml_doc.base_url = File.dirname(uri.path.to_s)
      xml_doc
    end

    private def load_local(path)
      if !File.exists?(path)
        raise "Could not fetch local Wsdl document #{path}"
      end
      xml_doc = XML.parse(File.read(path))
      xml_doc.base_url = File.dirname(path)
      xml_doc
    end
  end
end
