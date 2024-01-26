module Fetcher
  module Notion
    module Types
      class NotionResponse
        attr_reader :code, :message

        def initialize(json_response); end
      end
    end
  end
end
