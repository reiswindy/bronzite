require "../spec_helper"

describe "Bronzite::Document" do
  context "Using numberconversion.wsdl" do
    xml = Bronzite::Resolver.new(SpecHelper::Samples["numberconversion.wsdl"]).resolve
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
end
