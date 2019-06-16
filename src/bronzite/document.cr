module Bronzite
  class Document
    @base_uri : String
    @target_namespace : String
    @namespaces : Hash(String, String)
    @imports : Hash(String, Document)
    @messages : Hash(String, Wsdl::Message)
    @port_types : Hash(String, Wsdl::PortType)
    @bindings : Hash(String, Wsdl::Binding)
    @services : Hash(String, Wsdl::Service)

    def initialize(@base_uri, @target_namespace, @namespaces, @imports, @messages, @port_types, @bindings, @services)
    end

    getter :base_uri
    getter :target_namespace
    getter :namespaces
    getter :imports
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
      s_ports = Hash(Symbol, Hash(String, Wsdl::Port)).new(Hash(String, Wsdl::Port).new)
      @services.each do |s_name, service|
        service.ports.each do |p_name, port|
          case port.binding.type
          when :soap
            s_ports[:soap] = s_ports[:soap]
            s_ports[:soap][p_name] = port
          when :soap12
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
