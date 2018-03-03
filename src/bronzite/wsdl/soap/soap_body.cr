require "xml"

module Bronzite
  module Wsdl
    module Soap
      class SoapBody
        @use : String
        @parts : Array(Bronzite::Wsdl::Part)?
        @encoding_style : String?
        @namespace : String?

        def initialize(@use, @parts, @encoding_style, @namespace)
        end

        getter :use
        getter :parts
        getter :encoding_style
        getter :namespace

        def self.parse(node : XML::Node, ctx : Bronzite::Document)
          ns = Bronzite::Wsdl.parse_namespaces(node.namespaces)

          sb_use = node["use"]
          sb_parts = nil.as(Array(Bronzite::Wsdl::Part)?)

          if node["parts"]?
            op_node = node.not_nil!.parent.not_nil!.parent.not_nil!
            b_node = op_node.parent.not_nil!

            prefix, match, local = b_node["type"].rpartition(":")
            pt = ctx.port_types["#{ns[prefix]}:#{local}"]
            op = pt.operations["#{op_node["name"]}"]

            sb_parts = node["parts"].split(" ").reduce([] of Bronzite::Wsdl::Part) do |memo, p|
              memo.push(op.input.not_nil!.parts[p])
              memo
            end
          end

          sb_encoding_style = node["encodingStyle"]?
          sb_namespace = node["namespace"]?

          SoapBody.new(sb_use, sb_parts, sb_encoding_style, sb_namespace)
        end

        def ==(other : self)
          @use == other.use &&
          @parts == other.parts &&
          @encoding_style == other.encoding_style &&
          @namespace == other.namespace
        end
      end
    end
  end
end
