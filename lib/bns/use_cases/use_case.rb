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

      if response.length > 0
        mappings = mapper.map(response)

        formatted_payload = formatter.format(mappings)

        dispatcher.dispatch(formatted_payload)
      end
    end
  end
end
