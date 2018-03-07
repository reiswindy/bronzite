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
        ns = Bronzite::Wsdl.parse_namespaces(node.namespaces)

        sp_name = node["name"]

        prefix, match, local = node["binding"].rpartition(":")
        sp_binding = ctx.bindings["#{ns[prefix]}:#{local}"]?

        port_address = node.first_element_child.not_nil!
        sp_address = Address.parse(port_address)

        if sp_binding
          Port.new(sp_name, sp_binding, sp_address)
        end
      end

      def ==(other : self)
        @name == other.name &&
        @binding == other.binding &&
        @address == other.address
      end
    end
  end
end
