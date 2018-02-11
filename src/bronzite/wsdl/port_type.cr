require "xml"
require "./operation"

module Bronzite
  module Wsdl
    class PortType
      @name : String
      @qname : String
      @operations : Hash(String, Operation)

      def initialize(@name, @qname, @operations)
      end

      getter :name
      getter :qname
      getter :operations

      # Parse <portType> nodes and <operation> nodes.
      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        pt_name = node["name"]
        pt_qname = "#{ctx.target_namespace}:#{pt_name}"

        pt_operations = node.children.reduce({} of String => Operation) do |memo, e|
          if e.name == "operation"
            operation = Operation.parse(e, ctx)
            memo[operation.name] = operation
          end
          memo
        end

        PortType.new(pt_name, pt_qname, pt_operations)
      end

      def ==(other : self)
        @name == other.name &&
          @qname == other.qname &&
          @operations == other.operations
      end
    end
  end
end
