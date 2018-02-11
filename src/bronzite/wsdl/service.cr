require "xml"
require "./port"

module Bronzite
  module Wsdl
    class Service
      @name : String
      @ports : Hash(String, Port)

      def initialize(@name, @ports)
      end

      getter :name
      getter :ports

      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        s_name = node["name"]
        s_ports = node.children.reduce({} of String => Port) do |memo, e|
          case e.name
          when "port"
            sp = Port.parse(e, ctx)
            memo[sp.name] = sp
          end
          memo
        end

        Service.new(s_name, s_ports)
      end

      def ==(other : self)
        @name == other.name &&
          @ports == other.ports
      end
    end
  end
end
