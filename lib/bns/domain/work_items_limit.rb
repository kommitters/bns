# frozen_string_literal: true

module Domain
  ##
  # The Domain::WorkItem class provides a domain-specific representation of a Work Item object.
  # It encapsulates information about a work item, including the title, status, and domain.
  #
  class WorkItemsLimit
    attr_reader :domain, :total, :wip_limit

    ATTRIBUTES = %w[domain total wip_limit].freeze

    # Initializes a Domain::WorkItem instance with the specified title and status.
    #
    # <br>
    # <b>Params:</b>
    # * <tt>String</tt> 'domain' responsible domain of the work items.
    # * <tt>String</tt> 'total' total 'in progress' work items.
    # * <tt>String</tt> 'wip_limit' maximum 'in progress' work items for the domain
    #
    def initialize(domain, total, wip_limit)
      @domain = domain
      @total = total
      @wip_limit = wip_limit
    end
  end
end
