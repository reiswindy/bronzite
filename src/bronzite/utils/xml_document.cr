require "xml"

module Bronzite
  module Utils
    # Add base url to the LibXML Doc struct
    def self.set_node_doc_url(node : XML::Node, url : String)
      doc_ptr = node.document.to_unsafe.as(LibXML::Doc*)
      doc_ptr.value.url = url
    end

    # Retrieve base url of the LibXML Doc struct
    def self.get_node_doc_url(node : XML::Node)
      doc_ptr = node.document.to_unsafe.as(LibXML::Doc*)

      raise "Doc does not have a URL set" if doc_ptr.value.url.null?

      String.new(doc_ptr.value.url)
    end
  end
end
