module UseCases
    class UseCase
        attr_reader :fetcher
        attr_reader :dispatcher
        attr_reader :formatter

        def perform
            raise "Not implemented yet"
        end
    end
end