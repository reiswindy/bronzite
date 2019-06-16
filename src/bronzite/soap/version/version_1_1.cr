module Bronzite
  module Soap::Version::Soap_1_1
    extend Soap::Version

    NAMESPACE = "http://schemas.xmlsoap.org/wsdl/soap/"
    ENVELOPE = "http://schemas.xmlsoap.org/soap/envelope/"
    CONTENT_TYPE = "text/xml;charset=utf-8"

    def self.to_symbol
      :soap
    end

    def self.soap_namespace
      NAMESPACE
    end

    def self.envelope_namespace
      ENVELOPE
    end

    def self.build_headers(soap_action)
      http_headers = HTTP::Headers.new
      http_headers["Content-Type"] = CONTENT_TYPE
      http_headers["SOAPAction"] = soap_action
      http_headers
    end
  end
end
