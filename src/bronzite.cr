require "./bronzite/*"

# TODO: Write documentation for `Bronzite`
module Bronzite
  def self.parse(uri : String)
    xml_string = Bronzite::Resolver.new(uri).resolve
    Bronzite::Parser.new(xml_string).parse
  end
end
