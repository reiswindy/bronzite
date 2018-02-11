require "../spec_helper"

describe "Bronzite::Parser" do
  context "Using numberconversion.wsdl" do
    xml = Bronzite::Resolver.new(SpecHelper::Samples["numberconversion.wsdl"]).resolve
    parser = Bronzite::Parser.new(xml)
    document = parser.parse

    it "parses namespaces" do
      document.namespaces.should eq (
        {
          "xmlns"  => "http://schemas.xmlsoap.org/wsdl/",
          "xs"     => "http://www.w3.org/2001/XMLSchema",
          "soap"   => "http://schemas.xmlsoap.org/wsdl/soap/",
          "soap12" => "http://schemas.xmlsoap.org/wsdl/soap12/",
          "tns"    => "http://www.dataaccess.com/webservicesserver/",
        }
      )
    end

    it "parses messages" do
      document.messages.keys.should eq([
        "http://www.dataaccess.com/webservicesserver/:NumberToWordsSoapRequest",
        "http://www.dataaccess.com/webservicesserver/:NumberToWordsSoapResponse",
        "http://www.dataaccess.com/webservicesserver/:NumberToDollarsSoapRequest",
        "http://www.dataaccess.com/webservicesserver/:NumberToDollarsSoapResponse",
      ])
      document.messages["http://www.dataaccess.com/webservicesserver/:NumberToWordsSoapRequest"].should eq (
        Bronzite::Wsdl::Message.new(
          "NumberToWordsSoapRequest",
          "http://www.dataaccess.com/webservicesserver/:NumberToWordsSoapRequest",
          {"parameters" => Bronzite::Wsdl::Part.new("parameters", "NumberToWords")}
        )
      )
    end

    it "parses port types" do
      document.port_types.keys.should eq(["http://www.dataaccess.com/webservicesserver/:NumberConversionSoapType"])
      document.port_types["http://www.dataaccess.com/webservicesserver/:NumberConversionSoapType"].operations.keys.should eq([
        "NumberToWords",
        "NumberToDollars",
      ])
      document.port_types["http://www.dataaccess.com/webservicesserver/:NumberConversionSoapType"].operations["NumberToWords"].should eq(
        Bronzite::Wsdl::Operation.new(
          "NumberToWords",
          Bronzite::Wsdl::Message.new(
            "NumberToWordsSoapRequest",
            "http://www.dataaccess.com/webservicesserver/:NumberToWordsSoapRequest",
            {"parameters" => Bronzite::Wsdl::Part.new("parameters", "NumberToWords")}
          ),
          Bronzite::Wsdl::Message.new(
            "NumberToWordsSoapResponse",
            "http://www.dataaccess.com/webservicesserver/:NumberToWordsSoapResponse",
            {"parameters" => Bronzite::Wsdl::Part.new("parameters", "NumberToWordsResponse")}
          )
        )
      )
    end

    it "parses bindings" do
      document.bindings.keys.should eq([
        "http://www.dataaccess.com/webservicesserver/:NumberConversionSoapBinding",
        "http://www.dataaccess.com/webservicesserver/:NumberConversionSoapBinding12",
      ])
      document.bindings["http://www.dataaccess.com/webservicesserver/:NumberConversionSoapBinding"].should be_a(Bronzite::Wsdl::Soap::SoapBinding)
      document.bindings["http://www.dataaccess.com/webservicesserver/:NumberConversionSoapBinding12"].should be_a(Bronzite::Wsdl::Soap12::Soap12Binding)
    end

    it "parses services" do
      document.services.keys.should eq(["NumberConversion"])
      document.services["NumberConversion"].ports.keys.should eq([
        "NumberConversionSoap",
        "NumberConversionSoap12",
      ])
    end
  end

  context "using billservice.wsdl" do
    xml = Bronzite::Resolver.new(SpecHelper::Samples["billservice.wsdl"]).resolve
    parser = Bronzite::Parser.new(xml)
    document = parser.parse

    it "parses imports" do
      document.messages["http://service.sunat.gob.pe:getStatus"].should eq(
        Bronzite::Wsdl::Message.new(
          "getStatus",
          "http://service.sunat.gob.pe:getStatus",
          {"parameters" => Bronzite::Wsdl::Part.new("parameters", "getStatus")}
        )
      )
    end
  end
end
