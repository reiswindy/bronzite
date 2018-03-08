require "../spec_helper"

describe "Bronzite::Resolver" do
  context "with: Remote URI" do
    xml_doc = Bronzite::Resolver.new("http://www.dataaccess.com/webservicesserver/numberconversion.wso?wsdl").resolve

    it "fetches wsdl document from remote url using http" do
      xml_doc.should be_a(XML::Node)
    end
  end

  context "with: Local URI" do
    filename = SpecHelper::Samples["numberconversion.wsdl"]
    xml_doc = Bronzite::Resolver.new(filename).resolve

    it "fetches wsdl document from local directory" do
      xml_doc.should be_a(XML::Node)
    end
  end
end
