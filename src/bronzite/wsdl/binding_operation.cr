require "./binding_io"

module Bronzite
  module Wsdl
    abstract class BindingOperation
      @name : String
      @input : BindingIO?
      @output : BindingIO?

      def initialize(@name, @input, @output)
      end

      getter :name
      getter :input
      getter :output
    end
  end
end
