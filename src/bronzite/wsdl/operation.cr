require "xml"

module Bronzite
  module Wsdl
    class Operation
      # TODO: Use name input_output object instead of Message Element?
      @name : String
      @input : Message?
      @output : Message?

      def initialize(@name, @input = nil, @output = nil)
      end

      getter :name
      getter :input
      getter :output

      # Parse from <operation> node.
      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        o_name = node["name"]
        o_input = nil.as(Message?)
        o_output = nil.as(Message?)

        node.children.select { |c| c.name == "input" }.first?.try do |e|
          prefix, match, local = e["message"].rpartition(":")
          o_input = ctx.messages["#{ctx.namespaces[prefix]}:#{local}"]
        end

        node.children.select { |c| c.name == "output" }.first?.try do |e|
          prefix, match, local = e["message"].rpartition(":")
          o_output = ctx.messages["#{ctx.namespaces[prefix]}:#{local}"]
        end

        Operation.new(o_name, o_input, o_output)
      end

      def ==(other : self)
        @name == other.name &&
          @input == other.input &&
          @output == other.output
      end
    end
  end
end
