# frozen_string_literal: true

require_relative "../domain/exceptions/function_not_implemented"

module Formatter
  ##
  # The Formatter::Base module serves as the foundation for implementing specific data presentation logic
  # within the Formatter module. Defines essential methods, that provide a blueprint for creating custom
  # formatters tailored to different use cases.
  module Base
    # A method meant to give an specified format depending on the implementation to the data coming from an
    # implementation of the Mapper::Base interface.
    # Must be overridden by subclasses, with specific logic based on the use case.
    #
    #  @param [List<Domain::>] domain_data, List of specific domain objects depending on the use case.
    #
    #  @raise [Domain::Exceptions::FunctionNotImplemented] when missing implementation.
    #  @return [String] Formatted payload suitable for a Discord dispatch.
    def format(_domain_data)
      raise Domain::Exceptions::FunctionNotImplemented
    end
  end
end
