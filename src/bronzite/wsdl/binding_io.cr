require "./body"
require "./header"

module Bronzite
  module Wsdl
    class BindingIO
      @name : String?
      @body : Body
      @headers : Array(Header)

      def initialize(@name, @body, @headers)
      end

      getter :name
      getter :body
      getter :headers

      # TODO: Parse faults and other things
      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        io_name = node["name"]?

        io_body = Body.parse(node.children.select { |c| c.name == "body" }.first, ctx)
        io_headers = node.children.select { |c| c.name == "header" }.reduce([] of Header) do |memo, e|
          memo.push(Header.parse(e, ctx))
          memo
        end

        BindingIO.new(io_name, io_body, io_headers)
      end

      def ==(other : self)
        @name == other.name &&
        @body == other.body &&
        @headers == other.headers
      end
    end
  end
end
