require "xml"
require "./address"

module Bronzite
  module Wsdl
    class Port
      @name : String
      @binding : Binding
      @address : Address

      def initialize(@name, @binding, @address)
      end

      getter :name
      getter :binding
      getter :address

      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        sp_name = node["name"]

        prefix, match, local = node["binding"].rpartition(":")
        sp_binding = ctx.bindings["#{ctx.namespaces[prefix]}:#{local}"]

        sp_address = Address.parse(node.children.select { |c| c.name == "address" }.first)
        Port.new(sp_name, sp_binding, sp_address)
      end

      def ==(other : self)
        @name == other.name &&
          @binding == other.binding &&
          @address == other.address
      end
    end
  end
end
