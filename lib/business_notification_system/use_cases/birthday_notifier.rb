require_relative "business_notification_system/use_cases/use_case"

module UseCases
    class BirthdayNotifier < UseCase
        def initialize()
            @fetcher = NotionFetcher.new
            @dispatcher = dispatcher

            puts "BirthdayNotifier::initialize executed successfully"
        end

        def perform()
            fetcher.fetch()
            dispatcher.dispatch(fetcher.data)
            puts "BirthdayNotifier::perform executed successfully"
        end
    end
end