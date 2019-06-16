module Bronzite
  module Soap::Version::Soap_1_2
    extend Soap::Version

    NAMESPACE = "http://schemas.xmlsoap.org/wsdl/soap12/"
    ENVELOPE = "http://www.w3.org/2003/05/soap-envelope"
    CONTENT_TYPE = "application/soap+xml;charset=utf-8"

    def self.to_symbol
      :soap12
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
      http_headers
    end
  end
end
