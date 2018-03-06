require "xml"

module Bronzite
  module Wsdl
    class Address
      @location : String

      def initialize(@location)
      end

      getter :location

      def self.parse(node : XML::Node)
        a_location = node["location"]
        Address.new(a_location)
      end
    end
  end
end
