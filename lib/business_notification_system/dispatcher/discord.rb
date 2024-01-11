require_relative "base"

module Dispatcher
    class Discord < Base
        def initialize(config)
            @webhook = config[:webhook]
        end

        def dispatch(data)
            puts 'Dispatching data to discord via webhook...'
            puts data
        end
    end
end
