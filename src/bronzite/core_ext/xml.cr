require "xml"

struct XML::Node
  def base_url=(url : String)
    doc_ptr = document.to_unsafe.as(LibXML::Doc*)
    doc_ptr.value.url = url
  end

  def base_url
    doc_ptr = document.to_unsafe.as(LibXML::Doc*)
    raise "Document does not have a base url set" if doc_ptr.value.url.null?
    return String.new(doc_ptr.value.url)
  end
end
