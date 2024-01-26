# frozen_string_literal: true

require_relative "../../domain/pto"
require_relative "../base"

module Formatter
  module Discord
    class Pto
      include Base

      def format(data)
        # !TODO create exception
        raise "Invalid data format" unless data.all? { |element| element.is_a?(Domain::Pto) }

        template = ":beach: NAME is on PTO"
        payload = ""

        data.each do |pto|
          payload += "#{template.gsub("NAME", pto.individual_name)} #{build_pto_message(pto)}\n"
        end

        payload
      rescue ArgumentError => e
        puts "Formatter::Pto::Notion Error: #{e.message}"
      end

      private

      def build_pto_message(pto)
        if pto.start_date.include?("|")
          start_time = pto.start_date.split("|")
          end_time = pto.end_date.split("|")
          "#{start_time[1]} - #{end_time[1]}"
        else
          "all day"
        end
      end
    end
  end
end
