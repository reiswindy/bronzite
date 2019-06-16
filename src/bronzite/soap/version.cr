module Bronzite
  module Soap::Version
    abstract def to_symbol
    abstract def soap_namespace
    abstract def envelope_namespace
    abstract def build_headers(soap_function)

    def self.from_symbol(symbol : Symbol)
      case symbol
      when :soap
        Soap::Version::Soap_1_1
      when :soap12
        Soap::Version::Soap_1_2
      else
        raise "Invalid soap version"
      end
    end
  end
end
