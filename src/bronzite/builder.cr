module Bronzite
  class Builder
    @soap_version : Soap::Version

    def initialize(@soap_version)
    end

    def build(op_name, tns, body_parameters : Hash(String, Soap::Parameter)? = nil, input_headers : Hash(String, Soap::Parameter)? = nil)
      xml_request = XML.build(indent: "") do |xml|
        xml.element("Envelope", {"xmlns" => @soap_version.envelope_namespace}) do
          build_header(xml, input_headers) if input_headers
          build_body(op_name, tns, xml, body_parameters)
        end
      end
    end

    def build_header(xml, input_headers)
      xml.element("Header") do
        input_headers.each do |k, v|
          add_element(xml, k, v)
        end
      end
    end

    def build_body(op_name, tns, xml, body_parameters)
      xml.element("Body") do
        xml.element(op_name, {"xmlns" => tns}) do
          if body_parameters
            body_parameters.each do |k, v|
              add_element(xml, k, v)
            end
          end
        end
      end
    end

    def add_element(xml, key, element)
      attributes = {} of String => String
      attributes["xmlns"] = element.namespace.not_nil! if element.namespace

      xml.element(key, attributes) do
        case (value = element.value)
        when Hash
          value.each do |k, v|
            add_element(xml, k, v)
          end
        when Array
          value.each do |v|
            add_element(xml, key, v)
          end
        else
          xml.text(value.to_s)
        end
      end
    end
  end
end
