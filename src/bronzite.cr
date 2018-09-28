require "./bronzite/*"

# TODO: Write documentation for `Bronzite`
module Bronzite
  VERSION = "0.1.0"
  
  def self.parse(uri : String, version : Symbol = :soap)
    soap_client = Client.new(uri, version)
  end
end
