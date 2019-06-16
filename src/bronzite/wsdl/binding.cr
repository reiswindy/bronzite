module Bronzite
  module Wsdl
    class Binding
      @name : String
      @qname : String
      @port_type : PortType
      @binding_operations : Hash(String, BindingOperation)
      @transport : String
      @style : String
      @type : Symbol

      getter :name
      getter :qname
      getter :port_type
      getter :binding_operations
      getter :transport
      getter :style
      getter :type

      def initialize(@name, @qname, @port_type, @binding_operations, @transport, @style, @type)
      end

      def self.parse(binding_node : XML::Node, ctx : Bronzite::Document)
        ns = Bronzite::Wsdl.parse_namespaces(binding_node.namespaces)

        b_name = binding_node["name"]
        b_qname = "#{ctx.target_namespace}:#{b_name}"

        prefix, match, local = binding_node["type"].rpartition(":")
        b_port_type = ctx.port_types["#{ns[prefix]}:#{local}"]

        binding_binding = binding_node.first_element_child.not_nil!
        b_transport = binding_binding["transport"]
        b_style = binding_binding["style"]? || "document"

        b_type = nil.as(Symbol?)
        binding_binding.namespace.try do |binding_type|
          case url = binding_type.href.not_nil!
          when Bronzite::Wsdl::SOAP_1_1
            b_type = :soap
          when Bronzite::Wsdl::SOAP_1_2
            b_type = :soap12
          end
        end

        b_operations = binding_node.children.select { |c| c.name == "operation" }.reduce({} of String => Bronzite::Wsdl::BindingOperation) do |memo, e|
          sop = BindingOperation.parse(e, ctx)
          memo[sop.name] = sop
          memo
        end

        if b_type
          Binding.new(b_name, b_qname, b_port_type, b_operations, b_transport, b_style, b_type)
        end
      end

      def ==(other : self)
        @name == other.name &&
        @qname == other.qname &&
        @port_type == other.port_type &&
        @transport == other.transport &&
        @style == other.style &&
        @binding_operations == other.binding_operations
      end
    end
  end
end
