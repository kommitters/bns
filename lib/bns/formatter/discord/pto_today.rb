# frozen_string_literal: true

require_relative "../../domain/pto"
require_relative "../base"

module Formatter
  module Discord
    ##
    # This class is an implementation of the Formatter::Base interface, specifically designed for formatting PTO
    # data in a way suitable for Discord messages.
    class PtoToday < Base
      TEMPLATE = "individual_name is on PTO"

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
          built_template = build_template(TEMPLATE, Domain::Pto::ATTRIBUTES, pto)
          payload + format_message_by_case(built_template.gsub("\n", ""), pto)
        end
      end

      private

      def format_message_by_case(built_template, pto)
        date_start = format_timezone(pto.start_date).strftime("%F")
        date_end = format_timezone(pto.end_date).strftime("%F")

        if date_start == date_end
          interval = same_day_interval(pto)

          "#{built_template} #{interval}\n"
        else
          "#{built_template} from #{date_start} to #{date_end}\n"
        end
      end

      def same_day_interval(pto)
        time_start = format_timezone(pto.start_date).strftime("%I:%M %P")
        time_end = format_timezone(pto.end_date).strftime("%I:%M %P")

        time_start == time_end ? "all day" : "today from #{time_start} to #{time_end}"
      end

      def format_timezone(date)
        time_date = Time.new(date)

        @timezone.nil? ? time_date : Time.at(time_date, in: @timezone)
      end
    end
  end
end
