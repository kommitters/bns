require "httparty"

require_relative "../base"

module Fetcher
    module Birthday
        class Notion < Base
            def initialize(config)
                @data = []
                @config = config
            end

            def fetch()
                formatted_response = [{'name' => 'name1', 'birth_date' => '12-10-1994'}, {'name' => 'name2', 'birth_date' => '12-10-1996'}]
                puts "Fetcher Response => "
                puts formatted_response

                formatted_response
            end

            private

            def format_response()

            end
        end
    end
end
