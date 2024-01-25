# frozen_string_literal: true

require "httparty"
require "date"

require_relative "../base"
require_relative "../../exceptions/exceptions"

module Fetcher
  module Pto
    class Notion < Base
      def fetch
        url = "#{config[:base_url]}/v1/databases/#{config[:database_id]}/query"

        response = HTTParty.post(url, { body: config[:filter].to_json, headers: headers })
        validated_response = Exceptions::Notion.validate_response(response)

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

      def headers
        {
          "Authorization" => "Bearer #{config[:secret]}",
          "Content-Type" => "application/json",
          "Notion-Version" => "2022-06-28"
        }
      end

      def normalize(properties)
        normalized_value = {}

        properties.each do |k, v|
          extract_pto_fields(k, v, normalized_value)
        end

        normalized_value
      end

      def extract_pto_fields(key, value, normalized_value)
        case key
        when "Person"
          user_name = extract_person_field_value(value)
          normalized_value["name"] = user_name
        when "Desde?"
          normalized_value["start"] = extract_date_field_value(value)
        when "Hasta?"
          normalized_value["end"] = extract_date_field_value(value)
        end
      end

      def extract_person_field_value(data)
        data["people"][0]["name"]
      end

      def extract_date_field_value(data)
        data["date"]["start"]
      end
    end
  end
end
