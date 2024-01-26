# frozen_string_literal: true

module Exceptions
  module Notion
    class InvalidApiKey < StandardError
      def initialize(message = "The provided API token is invalid.")
        super(message)
      end
    end
  end
end
