require_relative "base"

module Dispatcher
    class Discord < Base
        def initialize(config)
            @webhook = config[:webhook]
            @name = config[:name]
        end

        def dispatch(payload)
            body = {
                username: name,
                avatar_url:'',
                content: payload
            }.to_json

            response = HTTParty.post(webhook, {
                body: body,
                headers: {
                    "Content-Type" => 'application/json'
                }
            })

            puts 'Dispatch successfully!'
        end
    end
end
