# frozen_string_literal: true

require "httparty"
require "date"

require_relative "../base"

module Fetcher
  module Birthday
    class Notion < Base
      def fetch
        url = "#{config[:base_url]}/v1/databases/#{config[:database_id]}/query"
        headers = {
          "Authorization" => "Bearer #{config[:secret]}",
          "Content-Type" => "application/json",
          "Notion-Version" => "2022-06-28"
        }

        response = HTTParty.post(url, { body: config[:filter].to_json, headers: headers })

        normalize_response(response["results"])
      end

      def normalize_response(response)
        normalized_response = []

        response.map do |value|
          properties = value["properties"]
          properties.delete("Name")

          formatted_value = normalize(properties)

          normalized_response.append(formatted_value)
        end

        normalized_response
      end

      private

      def normalize(properties)
        normalized_value = {}

        properties.each do |k, v|
          if k == "Full Name"
            normalized_value["name"] = extract_rich_text_field_value(v)
          else
            normalized_value["birth_date"] = extract_date_field_value(v)
          end
        end

        normalized_value
      end

      def extract_rich_text_field_value(data)
        data["rich_text"][0]["plain_text"]
      end

      def extract_date_field_value(data)
        data["date"]["start"]
      end
    end
  end
end
