# frozen_string_literal: true

require_relative "../../domain/pto"
require_relative "../base"

module Formatter
  module Discord
    ##
    # This class is an implementation of the Formatter::Base interface, specifically designed for formatting PTO
    # data in a way suitable for Discord messages.
    class Pto < Base
      # Implements the logic for building a formatted payload with the given template for PTO's.
      #
      # <br>
      # <b>Params:</b>
      # * <tt>List<Domain::Pto></tt> pto_list: List of mapped PTO's.
      #
      # <br>
      # <b>raises</b> <tt>Formatter::Discord::Exceptions::InvalidData</tt> when invalid data is provided.
      #
      # <br>
      # <b>returns</b> <tt>String</tt> payload, formatted payload suitable for a Discord message.
      #

      def format(ptos_list)
        raise Formatter::Discord::Exceptions::InvalidData unless ptos_list.all? { |pto| pto.is_a?(Domain::Pto) }

        ptos_list.reduce("") do |payload, pto|
          built_template = build_template(Domain::Pto::ATTRIBUTES, pto)
          payload + format_message_by_case(built_template.gsub("\n", ""), pto)
        end
      end

      private

      def format_message_by_case(built_template, pto)
        if pto.start_date.include?("|")
          start_time = pto.start_date.split("|")
          end_time = pto.end_date.split("|")
          "#{built_template} #{start_time[1]} - #{end_time[1]}\n"
        elsif pto.start_date == pto.end_date
          "#{built_template} all day\n"
        else
          "#{built_template} #{pto.start_date} - #{pto.end_date}\n"
        end
      end
    end
  end
end
