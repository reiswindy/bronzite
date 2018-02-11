require "spec"
require "../src/bronzite"

module SpecHelper
  Samples = Dir[File.join([File.expand_path(__DIR__), "sample_wsdl", "*.wsdl"])].reduce({} of String => String) do |memo, e|
    memo[File.basename(e)] = ["file://", e].join("")
    memo
  end
end
