# frozen_string_literal: true

require_relative "base"
require_relative "../exceptions/discord/invalid_webhook_token"
require_relative "../exceptions/exceptions"

module Dispatcher
  class Discord < Base
    def dispatch(payload)
      body = {
        username: name,
        avatar_url: "",
        content: payload
      }.to_json
      response = HTTParty.post(webhook, { body: body, headers: { "Content-Type" => "application/json" } })

      Exceptions::Discord.validate_response(response)
    end
  end
end
