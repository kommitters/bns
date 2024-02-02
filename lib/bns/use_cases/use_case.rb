# frozen_string_literal: true

module UseCases
  ##
  # The UseCases::UseCase class represents a generic structure for use cases within the system. It encapsulates the
  # logic flow by coordinating the execution of its components to fulfill a specific use case.
  class UseCase
    attr_reader :fetcher, :mapper, :formatter, :dispatcher

    # Initializes the use case with the necessary components.
    #  @param [Hash] options, Components required to run a use case
    def initialize(options)
      @fetcher = options[:fetcher]
      @mapper = options[:mapper]
      @formatter = options[:formatter]
      @dispatcher = options[:dispatcher]
    end

    # Executes the use case by orchestrating the sequential execution of the fetcher, mapper, formatter, and dispatcher.
    #  @return [Dispatcher::Discord::Types::Response]
    def perform
      response = fetcher.fetch

      mappings = mapper.map(response)

      formatted_payload = formatter.format(mappings)

      dispatcher.dispatch(formatted_payload)
    end
  end
end
