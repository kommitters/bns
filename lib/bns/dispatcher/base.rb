# frozen_string_literal: true

module Dispatcher
  class Base
    attr_reader :webhook, :name

    def initialize(config)
      @webhook = config[:webhook]
      @name = config[:name]
    end

    def dispatch(_payload)
      raise "Not implemented yet."
    end
  end
end
