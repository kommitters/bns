module Exceptions
  module Discord
    class InvalidWebook < StandardError
      def initialize(message = "The provided Webhook token is invalid.")
        super(message)
      end
    end
  end
end