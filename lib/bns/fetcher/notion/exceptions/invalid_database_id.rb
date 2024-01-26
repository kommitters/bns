# frozen_string_literal: true

module Exceptions
  module Notion
    class InvalidDatabaseId < StandardError
      def initialize(message = "The provided id doesn't match any database.")
        super(message)
      end
    end
  end
end
