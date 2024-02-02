module Dispatcher
  module Discord
    module Types
      class Response
        attr_reader :code, :http_code, :message, :response

        def initialize(response)
          @http_code = response.code
          @code = response["code"]
          @message = response.message
          @response = response.response
        end
      end
    end
  end
end
