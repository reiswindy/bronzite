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
        sp_binding = ctx.bindings["#{ns[prefix]}:#{local}"]

        port_address = node.first_element_child.not_nil!
        sp_address = Address.parse(port_address)

        is_soap = false
        port_address.namespace.try do |address_type|
          case url = address_type.href.not_nil!
          when Bronzite::Wsdl::SOAP_1_1, Bronzite::Wsdl::SOAP_1_2
            is_soap = true
          end
        end

        if is_soap
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
