require "http"
require "../spec_helper"

describe "Bronzite::Resolver" do
  context "with: Remote URI" do
    xml_doc = Bronzite::Resolver.new("http://www.dataaccess.com/webservicesserver/numberconversion.wso?wsdl").resolve

    it "fetches file from remote url using http" do
      xml_doc.contents.size.should be > 0
    end
  end

  context "with: Local URI" do
    filename = SpecHelper::Samples["numberconversion.wsdl"]
    xml_doc = Bronzite::Resolver.new(filename).resolve

    it "fetches file from local directory" do
      xml_doc.contents.size.should be > 0
    end
  end
end
