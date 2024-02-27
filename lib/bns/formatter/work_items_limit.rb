# frozen_string_literal: true

require_relative "../domain/work_items_limit"
require_relative "./exceptions/invalid_data"
require_relative "./base"

module Formatter
  ##
  # This class implements methods from the Formatter::Base module, tailored to format the
  # Domain::WorkItemsLimit structure for a dispatcher.
  class WorkItemsLimit < Base
    attr_reader :limit

    # Implements the logic for building a formatted payload with the given template for wip limits.
    #
    # <br>
    # <b>Params:</b>
    # * <tt>List<Domain::WorkItemsLimit></tt> work_items_list: List of mapped work items limits.
    #
    # <br>
    # <b>raises</b> <tt>Formatter::Exceptions::InvalidData</tt> when invalid data is provided.
    #
    # <br>
    # <b>returns</b> <tt>String</tt> payload, formatted payload suitable for a Dispatcher.
    #

    def format(work_items_list)
      raise Formatter::Exceptions::InvalidData unless work_items_list.all? do |work_item|
        work_item.is_a?(Domain::WorkItemsLimit)
      end

      excedded_domains(work_items_list).reduce("") do |payload, work_items_limit|
        payload + build_template(Domain::WorkItemsLimit::ATTRIBUTES, work_items_limit)
      end
    end

    private

    def excedded_domains(work_items_list)
      work_items_list.filter { |work_item| work_item.total > work_item.wip_limit }
    end
  end
end
