# frozen_string_literal: true

require_relative "../base"

module Fetcher
  module Notion
    ##
    # This class is an implementation of the Fetcher::Notion::Base interface, specifically designed
    # for counting "in progess" WI from the engineering work board in Notion.
    #
    class WorkItemsLimit < Notion::Base
      # Implements the data fetching count of "in progess" work items from Notion.
      #
      def fetch
        filter = {
          filter: {
            "and": [
              { property: "OK", formula: { string: { contains: "✅" } } },
              { "or": status_conditions }
            ]
          }
        }

        execute(filter)
      end

      private

      def status_conditions
        [
          { property: "Status", status: { equals: "In Progress" } },
          { property: "Status", status: { equals: "On Hold" } }
        ]
      end
    end
  end
end
