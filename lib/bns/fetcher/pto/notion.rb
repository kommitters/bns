# frozen_string_literal: true

require "httparty"
require "date"

require_relative "../base"

module Fetcher
  module Pto
    class Notion < Base
      def fetch
        url = "#{config[:base_url]}/v1/databases/#{config[:database_id]}/query"

        response = HTTParty.post(url, { body: config[:filter].to_json, headers: get_headers })
        validated_response = validate_response(response)

        normalize_response(validated_response["results"])
      end

      def normalize_response(response)
        return [] if response.nil?

        normalized_response = []

        response.map do |value|
          properties = value["properties"]
          properties.delete("Name")

          normalized_value = normalize(properties)

          normalized_response.append(normalized_value)
        end

        normalized_response
      end

      private

      def get_headers
        {
          "Authorization" => "Bearer #{config[:secret]}",
          "Content-Type" => "application/json",
          "Notion-Version" => "2022-06-28"
        }
      end

      def get_user_by_id(id)
        url = "https://api.notion.com/v1/users/#{id}"

        response = HTTParty.get(url, { body: config[:filter].to_json, headers: get_headers })

        validate_response(response)
      end

      def validate_response(response)
        error_codes = [401, 404]

        begin
          raise response["message"] if error_codes.include?(response["status"])

          response
        rescue ArgumentError => e
          puts "Fetcher::Pto::Notion Error: #{e.message}"
        end
      end

      def normalize(properties)
        normalized_value = {}

        properties.each do |k, v|
          extract_pto_fields(k, v, normalized_value)
        end

        normalized_value
      end

      def extract_pto_fields(key, value, normalized_value)
        if key == "Person"
          user_id = extract_person_field_value(value)
          user = get_user_by_id(user_id)

          normalized_value["name"] = user["name"]
        elsif key == "Desde? y Hasta?"
          dates = extract_complete_date_field_value(value)
          normalized_value["from"] = dates["start"]
          normalized_value["to"] = dates["end"]
        end
      end

      def extract_person_field_value(data)
        data["people"][0]["id"]
      end

      def extract_complete_date_field_value(data)
        {
          "start" => data["date"]["start"],
          "end" => data["date"]["end"]
        }
      end
    end
  end
end
