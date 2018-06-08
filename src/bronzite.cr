require "./bronzite/*"

# TODO: Write documentation for `Bronzite`
module Bronzite
  def self.parse(uri : String, version : Symbol = :soap)
    soap_client = Client.new(uri, version)
  end
end
