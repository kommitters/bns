# frozen_string_literal: true

require_relative "../../domain/birthday"
require_relative "../base"

module Mapper
  module Notion
    ##
    # This class implementats the methods of the Mapper::Base module, specifically designed for preparing or
    # shaping birthdays data coming from a Fetcher::Base implementation.
    class Birthday
      include Base

      # Implements the logic for shaping the results from a fetcher response.
      #
      #  @param [Fetcher::Notion::Types::Response] notion_response, Notion response object.
      #
      #  @return [List<Domain::Birthday>] birthdays_list, mapped birthdays to be used by a
      #     Formatter::Base implementation.
      def map(notion_response)
        return [] if notion_response.results.empty?

        normalized_notion_data = normalize_response(notion_response.results)

        normalized_notion_data.map do |birthday|
          Domain::Birthday.new(birthday["name"], birthday["birth_date"])
        end
      end

      private

      def normalize_response(results)
        return [] if results.nil?

        normalized_results = []

        results.map do |value|
          properties = value["properties"]
          properties.delete("Name")

          normalized_value = normalize(properties)

          normalized_results.append(normalized_value)
        end

        normalized_results
      end

      def normalize(properties)
        normalized_value = {}

        properties.each do |k, v|
          if k == "Complete Name"
            normalized_value["name"] = extract_rich_text_field_value(v)
          elsif k == "BD_this_year"
            normalized_value["birth_date"] = extract_date_field_value(v)
          end
        end

        normalized_value
      end

      def extract_rich_text_field_value(data)
        data["rich_text"][0]["plain_text"]
      end

      def extract_date_field_value(data)
        data["formula"]["date"]["start"]
      end
    end
  end
end
