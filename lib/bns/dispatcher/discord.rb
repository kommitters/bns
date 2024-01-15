# frozen_string_literal: true

require_relative "base"

module Dispatcher
  class Discord < Base
    def dispatch(payload)
      body = {
        username: name,
        avatar_url: "",
        content: payload
      }.to_json

      response = HTTParty.post(webhook, {
                                 body: body,
                                 headers: {
                                   "Content-Type" => "application/json"
                                 }
                               })
    end
  end
end
