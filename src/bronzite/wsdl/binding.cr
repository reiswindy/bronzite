require "xml"
require "./namespaces"
require "./binding_operation"

module Bronzite
  module Wsdl
    abstract class Binding
      @name : String
      @qname : String
      @port_type : PortType
      @binding_operations : Hash(String, BindingOperation)

      getter :name
      getter :qname
      getter :port_type
      getter :binding_operations

      def initialize(@name, @qname, @port_type, @binding_operations)
      end

      # TODO: Consider HTTP?
      def self.parse(binding_node : XML::Node, ctx : Bronzite::Document)
        bind = nil.as(Binding?)

        child = binding_node.children.select { |c| c.name == "binding" }.first

        case child.namespace.not_nil!.href
        when Bronzite::Wsdl::SOAP_1_1
          bind = Bronzite::Wsdl::Soap::SoapBinding.parse(binding_node, ctx)
        when Bronzite::Wsdl::SOAP_1_2
          bind = Bronzite::Wsdl::Soap12::Soap12Binding.parse(binding_node, ctx)
        end
        bind
      end
    end
  end
end

require "./soap/soap_binding"
require "./soap12/soap12_binding"
