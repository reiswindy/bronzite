require "xml"
require "uri"
require "http"

require "./bronzite/**"

# TODO: Write documentation for `Bronzite`
module Bronzite
  VERSION = "0.2.0"

  def self.parse(uri : String, version : Soap::Version = Soap::Version::Soap1_1)
    soap_client = Client.new(uri, version)
  end

  # Backwards compatibility
  def self.parse(uri : String, version : Symbol)
    soap_version = Soap::Version.from_symbol(version)
    soap_client = Client.new(uri, soap_version)
  end
end
