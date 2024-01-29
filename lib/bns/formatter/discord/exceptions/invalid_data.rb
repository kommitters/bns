# frozen_string_literal: true

module Formatter
  module Discord
    module Exceptions
      class InvalidData < StandardError
        def initialize(message = "")
          super(message)
        end
      end
    end
  end
end
