# frozen_string_literal: true

require_relative "../exceptions/function_not_implemented"

module Fetcher
  class Base
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def fetch
      raise Exceptions::FunctionNotImplemented
    end

    def normalize_response(_response)
      raise Exceptions::FunctionNotImplemented
    end
  end
end
