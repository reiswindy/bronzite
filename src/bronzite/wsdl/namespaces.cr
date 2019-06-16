module Bronzite
  module Wsdl
    XSD          = "http://www.w3.org/2001/XMLSchema"
    WSDL         = "http://schemas.xmlsoap.org/wsdl/"
    HTTP         = "http://schemas.xmlsoap.org/wsdl/http/"
    SOAP_1_1     = "http://schemas.xmlsoap.org/wsdl/soap/"
    SOAP_1_2     = "http://schemas.xmlsoap.org/wsdl/soap12/"

    def self.parse_namespaces(namespaces : Hash(String, String?))
      namespaces.reduce({} of String => String) do |accum, (key, value)|
        accum[key.sub("xmlns:", "")] = value.to_s
        accum
      end
    end
  end
end
