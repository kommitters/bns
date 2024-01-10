require_relative "../dispatcher"

module Services
    module Custom
        class DiscordDispatcher < Dispatcher
            def dispatch(data)
                puts 'Dispatching data to discord via webhook...'
            end
        end
    end
end