require "xml"

module Bronzite
  module Utils
    class XMLDocument
      @contents : String
      @base_uri : String

      def initialize(@contents, @base_uri)
      end

      getter :contents
      getter :base_uri
    end
  end
end
