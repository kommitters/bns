# frozen_string_literal: true

require_relative "base"
require_relative "./exceptions/discord/invalid_webhook_token"

module Dispatcher
  class Discord < Base
    def dispatch(payload)
      body = {
        username: name,
        avatar_url: "",
        content: payload
      }.to_json
      response = HTTParty.post(webhook, { body: body, headers: { "Content-Type" => "application/json" } })

      validate_response(response)
    end

    private

    def validate_response(response)
      case response["code"]
      when 50_027
        raise Exceptions::Discord::InvalidWebook, response["message"]
      else
        response
      end
    end
  end
end
