module Bronzite
  class Parser
    @xml_document : XML::Node

    def initialize(@xml_document)
    end

    def parse
      root = @xml_document.root
      if !root
        raise "Empty WSDL document received!"
      end

      w_base_uri = root.base_url
      w_target_namespace = root["targetNamespace"]
      w_namespaces = Wsdl.parse_namespaces(root.namespaces)

      w_imports = {} of String => Document
      w_messages = {} of String => Wsdl::Message
      w_port_types = {} of String => Wsdl::PortType
      w_bindings = {} of String => Wsdl::Binding
      w_services = {} of String => Wsdl::Service

      ctx = Bronzite::Document.new(w_base_uri, w_target_namespace, w_namespaces, w_imports, w_messages, w_port_types, w_bindings, w_services)

      root.children.each do |c|
        case name = c.name
        when "import"
          import_uri = File.join([w_base_uri, c["location"]])
          import_xml_doc = Resolver.new.resolve(import_uri)

          import_doc = Parser.new(import_xml_doc).parse

          # TODO: Handle types?
          import_doc.messages.each { |qname, m| ctx.messages[qname] = m }
          import_doc.port_types.each { |qname, pt| ctx.port_types[qname] = pt }
          import_doc.bindings.each { |qname, b| ctx.bindings[qname] = b }
          import_doc.services.each { |name, s| ctx.services[name] = s }

          ctx.imports[c["namespace"]] = import_doc
        when "types"
        when "message"
          message = parse_message(c, ctx)
          ctx.messages[message.qname] = message
        when "portType"
          port_type = parse_port_type(c, ctx)
          ctx.port_types[port_type.qname] = port_type
        when "binding"
          bindin = parse_binding(c, ctx)
          if bindin
            ctx.bindings[bindin.qname] = bindin
          end
        when "service"
          service = parse_service(c, ctx)
          ctx.services[service.name] = service
        else
        end
      end

      ctx
    end

    # Parse message from "message" nodes
    def parse_message(m_node : XML::Node, ctx : Document)
      Wsdl::Message.parse(m_node, ctx)
    end

    # Parse port_type from "portType" nodes
    def parse_port_type(pt_node : XML::Node, ctx : Document)
      Wsdl::PortType.parse(pt_node, ctx)
    end

    # Parse binding from "binding" nodes
    def parse_binding(b_node : XML::Node, ctx : Document)
      Wsdl::Binding.parse(b_node, ctx)
    end

    # Parse service from "service" nodes
    def parse_service(s_node : XML::Node, ctx : Document)
      Wsdl::Service.parse(s_node, ctx)
    end
  end
end
