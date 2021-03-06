require "../spec_helper"

describe Bronzite::Document do
  context "Using numberconversion.wsdl" do
    xml = Bronzite::Resolver.new.resolve(SpecHelper::Samples["numberconversion.wsdl"])
    parser = Bronzite::Parser.new(xml)
    document = parser.parse

    it "lists soap functions with elements" do
      document.soap_functions[:soap].should eq(
        {
          "NumberToWords"   => "NumberToWordsResponse NumberToWords(NumberToWords parameters)",
          "NumberToDollars" => "NumberToDollarsResponse NumberToDollars(NumberToDollars parameters)",
        }
      )
    end
  end

  context "Using calendar.wsdl" do
    xml = Bronzite::Resolver.new.resolve(SpecHelper::Samples["calendar.wsdl"])
    parser = Bronzite::Parser.new(xml)
    document = parser.parse

    it "lists soap functions with elements" do
      document.soap_functions[:soap].should eq(
        {
          "easter_date" => "string easter_date(short year)",
        }
      )
    end
  end
end
