require_relative "../base_dispatcher"

module Services
    module Custom
        class DiscordDispatcher < BaseDispatcher
            def dispatch(data)
                puts 'Dispatching data to discord via webhook...'
            end
        end
    end
end
