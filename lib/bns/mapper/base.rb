# frozen_string_literal: true

require_relative "../domain/exceptions/function_not_implemented"

module Mapper
  ##
  # The Mapper::Base module serves as the foundation for implementing specific data shaping logic within the
  # Mapper module. Defines essential methods, that provide a blueprint for organizing or shaping data in a manner
  # suitable for downstream formatting processes.
  module Base
    # An method meant to prepare or organize the data coming from an implementation of the Fetcher::Base interface.
    # Must be overridden by subclasses, with specific logic based on the use case.
    #
    #  @param [Fetcher::Notion::Types::Response] response, Response produced by a fetcher.
    #
    #  @raise [Domain::Exceptions::FunctionNotImplemented] when missing implementation.
    #  @return [List<Domain::>] Mapped list of data, ready to be formatted.
    def map(_response)
      raise Domain::Exceptions::FunctionNotImplemented
    end
  end
end
