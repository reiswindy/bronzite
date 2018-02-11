require "xml"
require "../binding"
require "./soap_operation"

module Bronzite
  module Wsdl
    module Soap
      class SoapBinding < Bronzite::Wsdl::Binding
        @transport : String
        @style : String

        def initialize(n, qn, pt, @transport, @style, bo)
          super(n, qn, pt, bo)
        end

        getter :transport
        getter :style

        def self.parse(node : XML::Node, ctx : Bronzite::Document)
          b_name = node["name"]
          b_qname = "#{ctx.target_namespace}:#{b_name}"

          prefix, match, local = node["type"].rpartition(":")
          b_port_type = ctx.port_types["#{ctx.namespaces[prefix]}:#{local}"]

          bind = node.children.select { |c| c.name == "binding" }.first
          b_transport = bind["transport"]
          b_style = (bind["style"]? || "document").not_nil!

          b_operations = node.children.select { |c| c.name == "operation" }.reduce({} of String => Bronzite::Wsdl::BindingOperation) do |memo, e|
            sop = SoapOperation.parse(e, ctx)
            memo[sop.name] = sop
            memo
          end

          SoapBinding.new(b_name, b_qname, b_port_type, b_transport, b_style, b_operations)
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
end
