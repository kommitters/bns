# frozen_string_literal: true

require 'pg'

require_relative "../base"
require_relative "./types/response"
require_relative "./helper"

module Fetcher
  module Postgres
    class Pto < Base
      attr_reader :connection, :query

      def initialize(config)
        @connection = config[:connection]
        @query = config[:query]
      end

      def fetch
        pg_connection = PG::Connection.new(connection)

        pg_result = pg_connection.exec(query)

        postgres_response = Fetcher::Postgres::Types::Response.new(pg_result)

        Fetcher::Postgres::Helper.validate_response(postgres_response)
      end
    end
  end
end
