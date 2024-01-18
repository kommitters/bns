# frozen_string_literal: true

module UseCases
  class UseCase
    attr_reader :fetcher, :mapper, :formatter, :dispatcher

    def initialize(options)
      @fetcher = options[:fetcher]
      @mapper = options[:mapper]
      @formatter = options[:formatter]
      @dispatcher = options[:dispatcher]
    end

    def perform
      response = fetcher.fetch

      return unless response.length.positive?

      mappings = mapper.map(response)

      formatted_payload = formatter.format(mappings)

      dispatcher.dispatch(formatted_payload)
    end
  end
end
