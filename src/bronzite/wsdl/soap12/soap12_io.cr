require "xml"
require "../binding_io"
require "./soap12_body"
require "./soap12_header"

module Bronzite
  module Wsdl
    module Soap12
      class Soap12IO < Bronzite::Wsdl::BindingIO
        @name : String?
        @body : Soap12Body
        @headers : Array(Soap12Header)

        def initialize(@name, @body, @headers)
        end

        getter :name
        getter :body
        getter :headers

        # TODO: Parse faults and other things
        def self.parse(node : XML::Node, ctx : Bronzite::Document)
          io_name = node["name"]?

          io_body = Soap12Body.parse(node.children.select { |c| c.name == "body" }.first, ctx)
          io_headers = node.children.select { |c| c.name == "header" }.reduce([] of Soap12Header) do |memo, e|
            memo.push(Soap12Header.parse(e, ctx))
            memo
          end

          Soap12IO.new(io_name, io_body, io_headers)
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
