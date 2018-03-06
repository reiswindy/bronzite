require "./message"

module Bronzite
  module Wsdl
    class HeaderFault
      @use : String
      @message : Message
      @part : Part
      @encoding_style : String?
      @namespace : String?

      def initialize(@use, @message, @part, @encoding_style, @namespace)
      end

      getter :use
      getter :message
      getter :part
      getter :encoding_style
      getter :namespace

      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        ns = Bronzite::Wsdl.parse_namespaces(node.namespaces)

        sh_use = node["use"]

        prefix, match, local = node["message"].rpartition(":")
        sh_message = ctx.messages["#{ns[prefix]}:#{local}"]
        sh_part = sh_message.parts[node["part"]]

        sh_encoding_style = node["encoding_style"]?
        sh_namespace = node["namespace"]?

        HeaderFault.new(sh_use, sh_message, sh_part, sh_encoding_style, sh_namespace)
      end

      def ==(other : self)
        @use == other.use &&
        @message == other.message &&
        @part == other.part &&
        @encoding_style == other.encoding_style &&
        @namespace == other.namespace
      end
    end
  end
end
