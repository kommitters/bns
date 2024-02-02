# frozen_string_literal: true

require_relative "../../domain/pto"
require_relative "../base"

module Formatter
  module Discord
    ##
    # This class is an implementation of the Formatter::Base interface, specifically designed for formatting PTO
    # data in a way suitable for Discord messages.
    class Pto
      include Base

      # Implements the logic for building a formatted payload with the given template for PTO's.
      #
      #  @param [List<Domain::Pto>] pto_list, List of mapped PTO's.
      #
      #  @raise [Formatter::Discord::Exceptions::InvalidData] when invalid data is provided.
      #  @return [String] payload, formatted payload suitable for a Discord message.
      def format(ptos_list)
        raise Formatter::Discord::Exceptions::InvalidData unless ptos_list.all? { |pto| pto.is_a?(Domain::Pto) }

        template = ":beach: NAME is on PTO"
        payload = ""

        ptos_list.each do |pto|
          payload += "#{template.gsub("NAME", pto.individual_name)} #{build_pto_message(pto)}\n"
        end

        payload
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
