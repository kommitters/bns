# frozen_string_literal: true

module Fetcher
  class Base
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def fetch
      raise "Not implemented yet."
    end

    def normalize_response(_response)
      raise "Not implemented yet."
    end
  end
end
