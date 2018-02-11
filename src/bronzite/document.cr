require "./wsdl/*"

module Bronzite
  class Document
    @target_namespace : String
    @namespaces : Hash(String, String)
    @messages : Hash(String, Bronzite::Wsdl::Message)
    @port_types : Hash(String, Bronzite::Wsdl::PortType)
    @bindings : Hash(String, Bronzite::Wsdl::Binding)
    @services : Hash(String, Bronzite::Wsdl::Service)

    def initialize(@target_namespace, @namespaces, @messages, @port_types, @bindings, @services)
    end

    getter :target_namespace
    getter :namespaces
    getter :messages
    getter :port_types
    getter :bindings
    getter :services

    def soap_functions
      functions = Hash(Symbol, Hash(String, String)).new(Hash(String, String).new)

      soap_ports.each do |version, s_ports|
        s_ports.each do |p_name, port|
          s_functions = generate_functions(port.binding.port_type.operations)
          if !s_functions.empty?
            functions[version] = s_functions
          end
        end
      end
      functions
    end

    # Returns all available soap ports, grouped by soap version
    def soap_ports
      s_ports = Hash(Symbol, Hash(String, Bronzite::Wsdl::Port)).new(Hash(String, Bronzite::Wsdl::Port).new)
      @services.each do |s_name, service|
        service.ports.each do |p_name, port|
          case port.binding
          when Bronzite::Wsdl::Soap::SoapBinding
            s_ports[:soap] = s_ports[:soap]
            s_ports[:soap][p_name] = port
          when Bronzite::Wsdl::Soap12::Soap12Binding
            s_ports[:soap12] = s_ports[:soap12]
            s_ports[:soap12][p_name] = port
          end
        end
      end
      s_ports
    end

    private def generate_functions(operations)
      o_functions = {} of String => String

      operations.each do |o_name, operation|
        f_name = o_name
        f_return = "void"
        f_parameters = [] of String
        if input = operation.input
          input.parts.each do |p_name, part|
            i_name = part.name
            i_element = part.element
            i_type_definition = part.type_definition
            if i_element
              f_parameters.push("#{i_element} #{i_name}")
            else
              f_parameters.push("#{i_type_definition} #{i_name}")
            end
          end
        end
        if output = operation.output
          o_element = output.parts.first_value.element
          o_type_definition = output.parts.first_value.type_definition
          if o_element
            f_return = o_element
          else
            f_return = o_type_definition
          end
        end
        o_functions[f_name] = "#{f_return} #{f_name}(#{f_parameters.join(", ")})"
      end
      o_functions
    end
  end
end
