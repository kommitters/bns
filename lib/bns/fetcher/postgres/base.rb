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

        pg_result = execute_query(pg_connection, query)

        postgres_response = Fetcher::Postgres::Types::Response.new(pg_result)

        Fetcher::Postgres::Helper.validate_response(postgres_response)
      end

      private

      def execute_query(pg_connection, query)
        if query.is_a? String
          pg_connection.exec(query)
        else
          sentence, params = query

          pg_connection.exec_params(sentence, params)
        end
      end
    end
  end
end
