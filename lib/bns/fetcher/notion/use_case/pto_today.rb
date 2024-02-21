# frozen_string_literal: true

require_relative "../base"

module Fetcher
  module Notion
    ##
    # This class is an implementation of the Fetcher::Base interface, specifically designed
    # for fetching Paid Time Off (PTO) data from Notion.
    #
    class PtoToday < Notion::Base
      # Implements the data fetching logic for PTO's data from Notion. It sends a POST
      # request to the Notion API to query the specified database and returns a validated response.
      #
      # <br>
      # <b>raises</b> <tt>Exceptions::Notion::InvalidApiKey</tt> if the API key provided is incorrect or invalid.
      #
      # <b>raises</b> <tt>Exceptions::Notion::InvalidDatabaseId</tt> if the Database id provided is incorrect
      # or invalid.
      #
      def fetch
        today = Time.now.utc.strftime('%F').to_s

        filter = {
          filter: {
            "and": [
              { property: 'Desde?', date: { on_or_before: today } },
              { property: 'Hasta?', date: { on_or_after: today } }
            ]
          }
        }

        execute(filter)
      end
    end
  end
end
