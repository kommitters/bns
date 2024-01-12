module Dispatcher
    class Base
        attr_reader :webhook, :name

        def dispatch(payload)
            raise "Not implemented yet."
        end
    end
end
