require "../spec_helper"

describe Bronzite::Client do
  context "using numberconversion.wsdl" do
    b_client = Bronzite.parse(SpecHelper::Samples["numberconversion.wsdl"])

    it "calls NumberToWords correctly via request method" do
      expected = <<-XML
<?xml version="1.0" encoding="utf-8"?>\r\n\
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">\r\n  \
<soap:Body>\r\n    \
<m:NumberToWordsResponse xmlns:m="http://www.dataaccess.com/webservicesserver/">\r\n      \
<m:NumberToWordsResult>one hundred </m:NumberToWordsResult>\r\n    \
</m:NumberToWordsResponse>\r\n  \
</soap:Body>\r\n</soap:Envelope>
XML

      body_params = {"ubiNum" => Bronzite::Soap::Parameter.new(100)}
      b_client.request("NumberToWords", body_params).should eq(expected)
    end
  end

  context "using calendar.wsdl" do
    b_client = Bronzite.parse(SpecHelper::Samples["calendar.wsdl"])

    it "calls easter_date correctly via request method" do
      expected = <<-XML
<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/1999/XMLSchema" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><namesp1:easter_dateResponse xmlns:namesp1="http://www.stgregorioschurchdc.org/Calendar"><s-gensym3 xsi:type="xsd:string">2020/04/12</s-gensym3></namesp1:easter_dateResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>
XML

      body_params = {"year" => Bronzite::Soap::Parameter.new(2020)}
      b_client.request("easter_date", body_params).should eq(expected)
    end
  end
end
