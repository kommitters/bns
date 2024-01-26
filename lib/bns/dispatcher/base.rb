# frozen_string_literal: true

require_relative "../domain/exceptions/function_not_implemented"

module Dispatcher
  class Base
    attr_reader :webhook, :name

    def initialize(config)
      @webhook = config[:webhook]
      @name = config[:name]
    end

    def dispatch(_payload)
      raise Exceptions::FunctionNotImplemented
    end
  end
end
