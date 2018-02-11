require "xml"
require "../binding_operation"
require "./soap_io"

module Bronzite
  module Wsdl
    module Soap
      class SoapOperation < Bronzite::Wsdl::BindingOperation
        @soap_action : String
        @style : String?

        def initialize(n, i, o, @soap_action, @style)
          super(n, i, o)
        end

        getter :soap_action
        getter :style

        def self.parse(node : XML::Node, ctx : Bronzite::Document)
          bo_name = node["name"]

          op = node.children.select { |c| c.name == "operation" }.first
          bo_soap_action = op["soapAction"]
          bo_style = op["style"]?

          bo_input = nil.as(BindingIO?)
          inp = node.children.select { |c| c.name == "input" }.first?
          if inp
            bo_input = SoapIO.parse(inp, ctx)
          end

          bo_output = nil.as(BindingIO?)
          outp = node.children.select { |c| c.name == "output" }.first?
          if outp
            bo_output = SoapIO.parse(outp, ctx)
          end

          SoapOperation.new(bo_name, bo_input, bo_output, bo_soap_action, bo_style)
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
end
