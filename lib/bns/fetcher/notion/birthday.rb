# frozen_string_literal: true

require "httparty"
require "date"

require_relative "../base"
require_relative "./exceptions/invalid_api_key"
require_relative "./exceptions/invalid_database_id"
require_relative "./types/response"
require_relative "./helper"

module Fetcher
  module Notion
    ##
    # This class is an implementation of the Fetcher::Base interface, specifically designed
    # for fetching birthday data from Notion.
    #
    class Birthday < Base
      # Implements the data fetching logic for Birthdays data from Notion. It sends a POST
      # request to the Notion API to query the specified database and returns a validated response.
      #
      # <br>
      # <b>raises</b> <tt>Exceptions::Notion::InvalidApiKey</tt> if the API key provided is incorrect or invalid.
      #
      # <b>raises</b> <tt>Exceptions::Notion::InvalidDatabaseId</tt> if the Database id provided is incorrect
      # or invalid.
      #
      def fetch
        url = build_url(config[:base_url], config[:database_id])

        httparty_response = HTTParty.post(url, { body: config[:filter].to_json, headers: headers })

        notion_response = Fetcher::Notion::Types::Response.new(httparty_response)

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

      def build_url(base, database_id)
        "#{base}/v1/databases/#{database_id}/query"
      end
    end
  end
end
