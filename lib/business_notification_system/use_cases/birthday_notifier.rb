require_relative "use_case"
require_relative "../services/custom/notion_fetcher"
require_relative "../services/custom/discord_dispatcher"

module UseCases
    class BirthdayNotifier < UseCase
        def initialize()
            @fetcher = Services::Custom::NotionFetcher.new("abc123")
            @dispatcher = Services::Custom::DiscordDispatcher.new

            puts "BirthdayNotifier::initialize executed successfully"
        end

        def perform()
            fetcher.fetch()
            dispatcher.dispatch(fetcher.data)
            puts "BirthdayNotifier::perform executed successfully"
        end
    end
end
