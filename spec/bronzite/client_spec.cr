require "../spec_helper"

describe Bronzite::Client do
  context "using numberconversion.wsdl" do
    b_client = Bronzite.parse(SpecHelper::Samples["numberconversion.wsdl"])

    expected =
      <<-XML
<?xml version="1.0" encoding="utf-8"?>\r\n\
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">\r\n  \
<soap:Body>\r\n    \
<m:NumberToWordsResponse xmlns:m="http://www.dataaccess.com/webservicesserver/">\r\n      \
<m:NumberToWordsResult>one hundred </m:NumberToWordsResult>\r\n    \
</m:NumberToWordsResponse>\r\n  \
</soap:Body>\r\n</soap:Envelope>
XML

    it "calls NumberToWords correctly via request method" do
      body_params = [{"ubiNum" => 100.as(Bronzite::Soap::Parameter)}]
      b_client.request("NumberToWords", body_params).should eq(expected)
    end
  end

end
