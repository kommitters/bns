# frozen_string_literal: true

module Dispatcher
  module Exceptions
    module Slack
      ##
      # Domain specific representation when an invalid webhook token is provided to Slack.
      #
      class InvalidWebookToken < StandardError
        def initialize(message = "The provided Webhook token is invalid.")
          super(message)
        end
      end
    end
  end
end
