require "http"
require "uri"
require "xml"
require "./utils/xml_document"

module Bronzite
  class Resolver
    @document = nil.as(XML::Node?)

    def initialize(@uri : String)
    end

    getter :document
    getter :uri

    def resolve
      uri = URI.parse(@uri)
      case uri.scheme
      when "http", "https"
        return load_remote(uri)
      when nil
        return load_local(@uri)
      end
      raise "Could not parse Uri"
    end

    private def load_remote(uri)
      response = HTTP::Client.get(uri)
      if !response.success?
        raise "Could not fetch remote Wsdl document #{uri}"
      end
      xml_doc = XML.parse(response.body)
      Bronzite::Utils.set_node_doc_url(xml_doc, File.dirname(uri.path.to_s))
      @document = xml_doc
    end

    private def load_local(path)
      if !File.exists?(path)
        raise "Could not fetch local Wsdl document #{path}"
      end
      xml_doc = XML.parse(File.read(path))
      Bronzite::Utils.set_node_doc_url(xml_doc, File.dirname(path))
      @document = xml_doc
    end
  end
end
