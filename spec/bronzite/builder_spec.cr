require "../spec_helper"

describe Bronzite::Builder do
  context "For wsdl" do
    builder = Bronzite::Builder.new(Bronzite::Soap::Version::Soap1_1)

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

    it "adds headers correctly" do
      expected =
        <<-XML
<?xml version="1.0"?>
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">\
    <Header>\
        <SecuTokenWS xmlns="http://tempuri.org/">\
            <UserName>username</UserName>\
            <Password>password</Password>\
            <AuthenticationToken>secret-token</AuthenticationToken>\
        </SecuTokenWS>\
    </Header>\
    <Body>\
        <getSexo xmlns="http://tempuri.org/"/>\
    </Body>\
</Envelope>

XML

      builder.build("getSexo", "http://tempuri.org/", nil,
        {
          "SecuTokenWS" => Bronzite::Soap::Parameter.from_hash({
            "UserName"            => "username",
            "Password"            => "password",
            "AuthenticationToken" => "secret-token",
          }, namespace: "http://tempuri.org/"),
        }
      ).should eq(expected)
    end
  end
end
