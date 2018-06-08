require "./builder"
require "./document"
require "./resolver"

module Bronzite
  class Client
    @builder : Bronzite::Builder
    @document : Bronzite::Document
    @functions : Hash(String, String)

    def initialize(uri : String, @version = :soap)
      resolver = Bronzite::Resolver.new(uri)
      resolver.resolve
      @builder = Bronzite::Builder.new(@version)
      @document = Bronzite::Parser.new(resolver.document.not_nil!).parse
      @functions = @document.soap_functions[@version]
    end

    def initialize(@document : Bronzite::Document, @version = :soap)
      @builder = Bronzite::Builder.new(@version)
      @functions = @document.soap_functions[@version]
    end

    getter document
    getter functions

    def request(function_name : String, body_parameters : Array(Bronzite::Parameter)? = nil, input_headers : Array(Bronzite::Parameter)? = nil)
      s_ports = @document.soap_ports[@version]
      s_port = s_ports.select {|sp_name, sp| sp.binding.port_type.operations.has_key?(function_name)}.first_value

      if !@functions.has_key?(function_name)
        raise "Unknown function #{function_name}"
      end

      location = s_port.address.location
      soap_action = s_port.binding.binding_operations[function_name].soap_action

      http_headers = HTTP::Headers.new
      http_headers["Content-Type"] = "text/xml;charset=utf-8"
      http_headers["SOAPAction"] = soap_action

      xml_request = @builder.build(function_name, @document.target_namespace, body_parameters, input_headers)

      response = HTTP::Client.post(location, http_headers, xml_request)
      response.body
    end
  end
end
