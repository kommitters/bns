# frozen_string_literal: true

require_relative "../../domain/work_items_limit"
require_relative "../base"

module Formatter
  module Discord
    ##
    # This class is an implementation of the Formatter::Base interface, specifically designed for formatting PTO
    # data in a way suitable for Discord messages.
    class WorkItemsLimit < Base
      attr_reader :limit

      TEMPLATE = "The domain work-board wip limit was exceeded, total of wip_limit"

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

      def format(work_items_list)
        raise Formatter::Discord::Exceptions::InvalidData unless work_items_list.all? do |work_item|
          work_item.is_a?(Domain::WorkItemsLimit)
        end

        excedded_domains(work_items_list).reduce("") do |payload, work_items_limit|
          payload + build_template(TEMPLATE, Domain::WorkItemsLimit::ATTRIBUTES, work_items_limit)
        end
      end

      private

      def excedded_domains(work_items_list)
        work_items_list.filter { |work_item| work_item.total > work_item.wip_limit }
      end
    end
  end
end
