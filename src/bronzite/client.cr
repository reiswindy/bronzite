module Bronzite
  class Client
    @builder : Builder
    @document : Document
    @functions : Hash(String, String)
    @version : Soap::Version

    def initialize(uri : String, @version = Soap::Version::Soap_1_1)
      document = Resolver.new.resolve(uri)
      @builder = Builder.new(@version)
      @document = Parser.new(document).parse
      @functions = @document.soap_functions[@version.to_symbol]
    end

    def initialize(@document : Document, @version = Soap::Version::Soap_1_1)
      @builder = Builder.new(@version)
      @functions = @document.soap_functions[@version.to_symbol]
    end

    getter document
    getter functions

    def request(function_name : String, body_parameters : Array(Soap::Parameter)? = nil, input_headers : Array(Soap::Parameter)? = nil)
      s_ports = @document.soap_ports[@version.to_symbol]
      s_port = s_ports.select {|sp_name, sp| sp.binding.port_type.operations.has_key?(function_name)}.first_value

      if !@functions.has_key?(function_name)
        raise "Unknown function #{function_name}"
      end

      soap_action = s_port.binding.binding_operations[function_name].soap_action
      http_headers = @version.build_headers(soap_action)

      xml_request = @builder.build(function_name, @document.target_namespace, body_parameters, input_headers)

      location = s_port.address.location
      response = HTTP::Client.post(location, http_headers, xml_request)
      response.body
    end
  end
end
