# frozen_string_literal: true

require "pg"

require_relative "../base"
require_relative "./types/response"
require_relative "./helper"

module Fetcher
  module Postgres
    ##
    # This class is an implementation of the Fetcher::Base interface, specifically designed
    # for fetching birthday data from Notion.
    #
    class Base < Fetcher::Base

      protected

      def execute(query)
        pg_connection = PG::Connection.new(config[:connection])

        pg_result = pg_connection.exec(query)

        postgres_response = Fetcher::Postgres::Types::Response.new(pg_result)

        Fetcher::Postgres::Helper.validate_response(postgres_response)
      end
    end
  end
end
