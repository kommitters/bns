# frozen_string_literal: true

module Fetcher
  class Base
    attr_reader :config

    def fetch
      raise "Not implemented yet."
    end

    def format_response(_response)
      raise "Not implemented yet."
    end
  end
end
