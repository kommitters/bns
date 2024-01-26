# frozen_string_literal: true

require_relative "../domain/exceptions/function_not_implemented"

module Mapper
  module Base
    def map(_response)
      raise Domain::Exceptions::FunctionNotImplemented
    end
  end
end
