module Bronzite
  class Client
    @builder : Builder
    @document : Document
    @functions : Hash(String, String)
    @version : Soap::Version

    def initialize(uri : String, @version = Soap::Version::Soap1_1)
      document = Resolver.new.resolve(uri)
      @builder = Builder.new(@version)
      @document = Parser.new(document).parse
      @functions = @document.soap_functions[@version.to_symbol]
    end

    def initialize(@document : Document, @version = Soap::Version::Soap1_1)
      @builder = Builder.new(@version)
      @functions = @document.soap_functions[@version.to_symbol]
    end

    getter :document
    getter :functions

    def request(function_name : String, soap_body : Hash(String, Soap::Parameter)? = nil, soap_header : Hash(String, Soap::Parameter)? = nil)
      raise "Unknown function #{function_name}" if !@functions.has_key?(function_name)

      s_ports = @document.soap_ports[@version.to_symbol]
      s_port = s_ports.select {|sp_name, sp| sp.binding.port_type.operations.has_key?(function_name)}.first_value

      soap_action = s_port.binding.binding_operations[function_name].soap_action
      http_headers = @version.build_headers(soap_action)

      xml_request = @builder.build(function_name, @document.target_namespace, soap_body, soap_header)

      location = s_port.address.location
      response = HTTP::Client.post(location, http_headers, xml_request)
      response.body
    end
  end
end
