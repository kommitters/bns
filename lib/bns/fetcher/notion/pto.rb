# frozen_string_literal: true

require "httparty"
require "date"

require_relative "../base"
require_relative "./exceptions/invalid_api_key"
require_relative "./exceptions/invalid_database_id"

module Fetcher
  module Notion
    class Pto < Base
      def fetch
        url = "#{config[:base_url]}/v1/databases/#{config[:database_id]}/query"

        response = HTTParty.post(url, { body: config[:filter].to_json, headers: headers })
        validate_response(response)
      end

      def validate_response(response)
        case response["status"]
        when 401
          raise Exceptions::Notion::InvalidApiKey, response["message"]
        when 404
          raise Exceptions::Notion::InvalidDatabaseId, response["message"]
        else
          response
        end
      end

      private

      def headers
        {
          "Authorization" => "Bearer #{config[:secret]}",
          "Content-Type" => "application/json",
          "Notion-Version" => "2022-06-28"
        }
      end
    end
  end
end
