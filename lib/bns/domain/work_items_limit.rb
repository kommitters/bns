# frozen_string_literal: true

module Domain
  ##
  # The Domain::WorkItemsLimit class provides a domain-specific representation of a Work Item object.
  # It encapsulates information about a work items limit, including the domain, total, and wip_limit.
  #
  class WorkItemsLimit
    attr_reader :domain, :total, :wip_limit

    ATTRIBUTES = %w[domain total wip_limit].freeze

    # Initializes a Domain::WorkItemsLimit instance with the specified domain, total and wip_limit.
    #
    # <br>
    # <b>Params:</b>
    # * <tt>String</tt> 'domain' responsible domain of the work items.
    # * <tt>String</tt> 'total' total 'in progress' work items.
    # * <tt>String</tt> 'wip_limit' maximum 'in progress' work items for the domain
    #
    def initialize(domain, total)
      @domain = domain
      @total = total
      @wip_limit = domain_wip_limit(domain)
    end

    private

    def domain_wip_limit(domain)
      case domain
      when "kommit.ops" then 6
      when "kommit.sales" then 3
      when "kommit.marketing" then 4
      when "kommit.engineering" then 12
      else 6
      end
    end
  end
end
