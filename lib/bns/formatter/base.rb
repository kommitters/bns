# frozen_string_literal: true

require_relative "../domain/exceptions/function_not_implemented"

module Formatter
  module Base
    def format(_data)
      raise Domain::Exceptions::FunctionNotImplemented
    end
  end
end
