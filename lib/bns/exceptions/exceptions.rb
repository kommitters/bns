# frozen_string_literal: true

require_relative "./discord/invalid_webhook_token"
require_relative "./notion/invalid_api_key"
require_relative "./notion/invalid_database_id"

module Exceptions
  module Discord
    def self.validate_response(response)
      case response["code"]
      when 50_027
        raise Exceptions::Discord::InvalidWebook, response["message"]
      else
        response
      end
    end
  end

  module Notion
    def self.validate_response(response)
      case response["status"]
      when 401
        raise Exceptions::Notion::InvalidApiKey, response["message"]
      when 404
        raise Exceptions::Notion::InvalidDatabaseId, response["message"]
      else
        response
      end
    end
  end
end
