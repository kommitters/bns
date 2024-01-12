# frozen_string_literal: true

module Dispatcher
  class Base
    attr_reader :webhook, :name

    def dispatch(_payload)
      raise "Not implemented yet."
    end
  end
end
