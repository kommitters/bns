# frozen_string_literal: true

require_relative "../exceptions/function_not_implemented"

module Mapper
  module Base
    def map(_response)
      raise Exceptions::FunctionNotImplemented
    end

    private

    def normalize_response(_response)
      raise Exceptions::FunctionNotImplemented
    end
  end
end
