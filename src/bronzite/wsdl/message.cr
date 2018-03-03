require "xml"
require "./part"

module Bronzite
  module Wsdl
    class Message
      @name : String
      @qname : String
      @parts : Hash(String, Part)

      def initialize(@name, @qname, @parts = {} of String => Part)
      end

      getter :name
      getter :qname
      getter :parts

      # Parse <message> node and <part> children nodes.
      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        m_name = node["name"]
        m_qname = "#{ctx.target_namespace}:#{m_name}"

        m_parts = node.children.reduce({} of String => Part) do |memo, e|
          if e.name == "part"
            part = Part.parse(e, ctx)
            memo[part.name] = part
          end
          memo
        end

        Message.new(m_name, m_qname, m_parts)
      end

      def ==(other : self)
        @name == other.name &&
        @qname == other.qname &&
        @parts == other.parts
      end
    end
  end
end
