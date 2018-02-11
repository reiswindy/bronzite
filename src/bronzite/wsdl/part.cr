require "xml"

module Bronzite
  module Wsdl
    class Part
      @name : String
      @element : String?
      @type_definition : String?

      def initialize(@name, @element = nil, @type_definition = nil)
      end

      getter :name
      getter :element
      getter :type_definition

      # Parse part data from <Part> node
      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        p_name = node["name"]
        p_element = node["element"]?
        p_type_definition = node["type"]?

        # TODO:Parse elements
        if p_element
          prefix, match, local = p_element.rpartition(":")
          p_element = local
        end

        # TODO:Parse elements
        if p_type_definition
          prefix, match, local = p_type_definition.rpartition(":")
          p_type_definition = local
        end

        Part.new(p_name, p_element, p_type_definition)
      end

      def ==(other : self)
        @name == other.name &&
          @element == other.element &&
          @type_definition == other.type_definition
      end
    end
  end
end
