require "http"
require "../spec_helper"

describe "Bronzite::Resolver" do
  context "with: Remote URI" do
    resolver = Bronzite::Resolver.new("http://www.tepsa.com.pe/wssisvyr/SisvyrService?wsdl")

    it "fetches file from remote url using http" do
      resolver.resolve.size.should be > 0
    end
  end

  context "with: Local URI" do
    filename = SpecHelper::Samples["numberconversion.wsdl"]
    resolver = Bronzite::Resolver.new(filename)

    it "fetches file from local directory" do
      resolver.resolve.size.should be > 0
    end
  end
end
