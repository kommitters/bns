# frozen_string_literal: true

require_relative "../base"

module Fetcher
  module Notion
    ##
    # This class is an implementation of the Fetcher::Base interface, specifically designed
    # for fetching birthday data from Notion.
    #
    class BirthdayToday < Notion::Base
      # Implements the data fetching logic for Birthdays data from Notion. It sends a POST
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
          filter:{
            or: [
              {
                property: 'BD_this_year',
                date: { equals: today }
              }
            ]
          }
        }

        execute(filter)
      end
    end
  end
end
