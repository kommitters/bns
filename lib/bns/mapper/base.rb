# frozen_string_literal: true

require_relative "../exceptions/function_not_implemented"

module Mapper
  module Base
    def map(_data)
      raise Exceptions::FunctionNotImplemented
    end
  end
end
