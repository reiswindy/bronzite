module Bronzite
  module Wsdl
    class BindingOperation
      @name : String
      @input : BindingIO?
      @output : BindingIO?
      @soap_action : String
      @style : String?

      def initialize(@name, @input, @output, @soap_action, @style)
      end

      getter :name
      getter :input
      getter :output
      getter :soap_action
      getter :style

      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        bo_name = node["name"]

        operation_operation = node.first_element_child.not_nil!
        bo_soap_action = operation_operation["soapAction"]
        bo_style = operation_operation["style"]?

        bo_input = nil.as(BindingIO?)
        bo_output = nil.as(BindingIO?)

        inp = node.children.select { |c| c.name == "input" }.first?
        if inp
          bo_input = BindingIO.parse(inp, ctx)
        end

        outp = node.children.select { |c| c.name == "output" }.first?
        if outp
          bo_output = BindingIO.parse(outp, ctx)
        end

        BindingOperation.new(bo_name, bo_input, bo_output, bo_soap_action, bo_style)
      end

      def ==(other : self)
        @name == other.name &&
        @input == other.input &&
        @output == other.output &&
        @soap_action == other.soap_action &&
        @style == other.style
      end
    end
  end
end
