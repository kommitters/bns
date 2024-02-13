# frozen_string_literal: true

require_relative "../../domain/pto"
require_relative "../base"

module Mapper
  module Postgres
    class Pto

      def map(pg_response)
        return [] if pg_response.records.empty?

        ptos = build_map(pg_response)

        ptos.map do |pto|
          name = pto["individual_name"]
          start_date = pto["start_date"]
          end_date = pto["end_date"]

          Domain::Pto.new(name, start_date, end_date)
        end
      end

      private

      def build_map(pg_response)
        fields = pg_response.fields
        values = pg_response.records

        values.map { |value| Hash[fields.zip(value)] }
      end
    end
  end
end
