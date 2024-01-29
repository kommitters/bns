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

        httparty_response = HTTParty.post(url, { body: config[:filter].to_json, headers: headers })

        notion_response = Fetcher::Notion::Types::NotionResponse.new(httparty_response)

        Fetcher::Notion::Helper.validate_response(notion_response)
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
