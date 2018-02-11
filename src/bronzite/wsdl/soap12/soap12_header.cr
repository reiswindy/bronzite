require "xml"
require "./soap12_header_fault"

module Bronzite
  module Wsdl
    module Soap12
      class Soap12Header
        @use : String
        @message : Bronzite::Wsdl::Message
        @part : Bronzite::Wsdl::Part
        @encoding_style : String?
        @namespace : String?
        @header_faults : Array(Soap12HeaderFault)

        def initialize(@use, @message, @part, @encoding_style, @namespace, @header_faults)
        end

        getter :use
        getter :message
        getter :part
        getter :encoding_style
        getter :namespace
        getter :header_faults

        def self.parse(node : XML::Node, ctx : Bronzite::Document)
          sh_use = node["use"]

          prefix, match, local = node["message"].rpartition(":")
          sh_message = ctx.messages["#{ctx.namespaces[prefix]}:#{local}"]
          sh_part = sh_message.parts[node["part"]]

          sh_encoding_style = node["encoding_style"]?
          sh_namespace = node["namespace"]?

          faults = node.children.select { |c| c.name == "headerfault" }
          sh_header_faults = faults.reduce([] of Soap12HeaderFault) do |memo, e|
            memo.push(Soap12HeaderFault.parse(e, ctx))
            memo
          end

          Soap12Header.new(sh_use, sh_message, sh_part, sh_encoding_style, sh_namespace, sh_header_faults)
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
end