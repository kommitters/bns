# frozen_string_literal: true

require "pg"

require_relative "../base"
require_relative "./types/response"
require_relative "./helper"

module Fetcher
  module Postgres
    ##
    # This class is an implementation of the Fetcher::Base interface, specifically designed
    # for fetching Paid Time Off (PTO) data from a Postgres Database.
    #
    class Pto < Base
      attr_reader :connection, :query

      # Initializes the Postgres fetcher with essential configuration parameters.
      #
      # <b>connection config</b> : valid format are the same as the ones defined on the pg gem (https://deveiate.org/code/pg/PG/Connection.html)
      # <br>
      # <b>query format</b> : valid format are the same as the ones defined on the pg gem (https://deveiate.org/code/pg/PG/Connection.html)
      def initialize(config)
        super(config)

        @connection = config[:connection]
        @query = config[:query]
      end

      # Implements the data fetching logic for PTO's data from a Postgres database. It use the PG gem
      # to request data from a local or external database and returns a validated response.
      #
      # Gem: pg (https://rubygems.org/gems/pg)
      #
      def fetch
        pg_connection = PG::Connection.new(connection)

        pg_result = pg_connection.exec(query)

        postgres_response = Fetcher::Postgres::Types::Response.new(pg_result)

        Fetcher::Postgres::Helper.validate_response(postgres_response)
      end
    end
  end
end
