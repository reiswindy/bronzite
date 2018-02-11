require "xml"

module Bronzite
  module Wsdl
    module Soap12
      class Soap12HeaderFault
        @use : String
        @message : Bronzite::Wsdl::Message
        @part : Bronzite::Wsdl::Part
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
          sh_use = node["use"]

          prefix, match, local = node["message"].rpartition(":")
          sh_message = ctx.messages["#{ctx.namespaces[prefix]}:#{local}"]
          sh_part = sh_message.parts[node["part"]]

          sh_encoding_style = node["encoding_style"]?
          sh_namespace = node["namespace"]?

          Soap12HeaderFault.new(sh_use, sh_message, sh_part, sh_encoding_style, sh_namespace)
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
end
