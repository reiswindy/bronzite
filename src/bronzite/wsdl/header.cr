module Bronzite
  module Wsdl
    class Header
      @use : String
      @message : Message
      @part : Part
      @encoding_style : String?
      @namespace : String?
      @header_faults : Array(HeaderFault)

      def initialize(@use, @message, @part, @encoding_style, @namespace, @header_faults)
      end

      getter :use
      getter :message
      getter :part
      getter :encoding_style
      getter :namespace
      getter :header_faults

      def self.parse(node : XML::Node, ctx : Bronzite::Document)
        ns = Bronzite::Wsdl.parse_namespaces(node.namespaces)

        sh_use = node["use"]

        prefix, match, local = node["message"].rpartition(":")
        sh_message = ctx.messages["#{ns[prefix]}:#{local}"]
        sh_part = sh_message.parts[node["part"]]

        sh_encoding_style = node["encoding_style"]?
        sh_namespace = node["namespace"]?

        faults = node.children.select { |c| c.name == "headerfault" }
        sh_header_faults = faults.reduce([] of HeaderFault) do |memo, e|
          memo.push(HeaderFault.parse(e, ctx))
          memo
        end

        Header.new(sh_use, sh_message, sh_part, sh_encoding_style, sh_namespace, sh_header_faults)
      end

      def ==(other : self)
        @use == other.use &&
        @message == other.message &&
        @part == other.part &&
        @encoding_style == other.encoding_style &&
        @namespace == other.namespace &&
        @header_faults == other.header_faults
      end
    end
  end
end
