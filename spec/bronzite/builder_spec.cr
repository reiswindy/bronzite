require "../spec_helper"

describe Bronzite::Builder do
  context "For wsdl" do
    builder = Bronzite::Builder.new(Bronzite::Soap::Version::Soap_1_1)

    it "builds correct request" do
      expected =
        <<-XML
<?xml version="1.0"?>
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">\
    <Body>\
        <getGenerico xmlns="http://ws.wssisvyr.tepsa.com/">\
            <seguridad>\
                <clave>GenericPassword</clave>\
                <ruc>31231231223</ruc>\
                <usuario>username</usuario>\
                <usuarioHardware>123</usuarioHardware>\
            </seguridad>\
        </getGenerico>\
    </Body>\
</Envelope>

XML
      builder.build("getGenerico", "http://ws.wssisvyr.tepsa.com/",
        {
          "seguridad" => Bronzite::Soap::Parameter.from_hash({
            "clave"           => "GenericPassword",
            "ruc"             => "31231231223",
            "usuario"         => "username",
            "usuarioHardware" => "123",
          }),
        }
      ).should eq(expected)
    end
  end
end
