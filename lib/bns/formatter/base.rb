# frozen_string_literal: true

require_relative "../domain/exceptions/function_not_implemented"

module Formatter
  module Base
    def format(_data)
      raise Exceptions::FunctionNotImplemented
    end
  end
end
