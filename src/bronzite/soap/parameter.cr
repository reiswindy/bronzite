module Bronzite
  module Soap
    alias Parameter = Int8 | Int16 | Int32 | Int64 | UInt8 | UInt16 | UInt32 | UInt64 | UInt128 | Float32 | Float64 | String | Array(Parameter) | Hash(String, Parameter)
  end
end
