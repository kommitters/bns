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
        validated_response = validate_response(response)

        normalize_response(validated_response["results"])
      end

      def normalize_response(response)
        return [] if response.nil?

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

      def validate_response(response)
        error_codes = [401, 404]

        begin
          raise response["message"] if error_codes.include?(response["status"])

          response
        rescue ArgumentError => e
          puts "Fetcher::Birthday::Notion Error: #{e.message}"
        end
      end

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
