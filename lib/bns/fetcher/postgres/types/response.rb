# frozen_string_literal: true

module Fetcher
  module Postgres
    module Types
      ##
      # Represents a response received from the Postgres API. It encapsulates essential information about the response,
      # providing a structured way to handle and analyze it's responses.
      class Response
        attr_reader :status, :message, :response, :fields, :records

        SUCCESS_STATUS = 'PGRES_TUPLES_OK'

        def initialize(response)
          status = response.res_status()

          if status == SUCCESS_STATUS
            @status = status
            @message = 'success'
            @response = response
            @fields = response.fields()
            @records = response.values
          else
            @status = status
            @message = response.result_error_message()
            @response = response
            @fields = nil
            @records = nil
          end
        end
      end
    end
  end
end
