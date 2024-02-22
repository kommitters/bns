# frozen_string_literal: true

require_relative "../base"

module Fetcher
  module Postgres
    ##
    # This class is an implementation of the Fetcher::Base interface, specifically designed
    # for fetching Paid Time Off (PTO) data from a Postgres Database.
    #
    class PtoToday < Base
      # Implements the data fetching logic for PTO's data from a Postgres database. It use the PG gem
      # to request data from a local or external database and returns a validated response.
      #
      # Gem: pg (https://rubygems.org/gems/pg)
      #
      def fetch
        today = Time.now.utc.strftime('%F').to_s

        start_time = "#{today}T00:00:00"
        end_time = "#{today}T23:59:59"

        query = "SELECT * FROM pto WHERE (start_date <= '#{today}' AND end_date >= '#{today}') OR (start_date>= '#{start_time}' AND end_date <= '#{end_time}')"

        execute(query)
      end
    end
  end
end
