require "xml"
require "../binding_io"
require "./soap_body"
require "./soap_header"

module Bronzite
  module Wsdl
    module Soap
      class SoapIO < Bronzite::Wsdl::BindingIO
        @name : String?
        @body : SoapBody
        @headers : Array(SoapHeader)

        def initialize(@name, @body, @headers)
        end

        getter :name
        getter :body
        getter :headers

        # TODO: Parse faults and other things
        def self.parse(node : XML::Node, ctx : Bronzite::Document)
          io_name = node["name"]?

          io_body = SoapBody.parse(node.children.select { |c| c.name == "body" }.first, ctx)
          io_headers = node.children.select { |c| c.name == "header" }.reduce([] of SoapHeader) do |memo, e|
            memo.push(SoapHeader.parse(e, ctx))
            memo
          end

          SoapIO.new(io_name, io_body, io_headers)
        end

        def ==(other : self)
          @name == other.name &&
            @body == other.body &&
            @headers == other.headers
        end
      end
    end
  end
end
