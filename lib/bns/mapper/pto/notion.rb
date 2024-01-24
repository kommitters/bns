# frozen_string_literal: true

require_relative "../../domain/pto"
require_relative "../base"

module Mapper
  module Pto
    class Notion
      include Base

      def map(data)
        data.map do |pto|
          Domain::Pto.new(pto["name"], format_date(pto["start"]), format_date(pto["end"]))
        end
      end

      private

      def format_date(str_date)
        return "" if str_date.nil?

        if str_date.include?("T")
          format = "%Y-%m-%d|%I:%M %p"
          datetime = Time.new(str_date)
          datetime.strftime(format)
        else
          str_date
        end
      end
    end
  end
end
