require 'uri'
require 'net/http'
require_relative "../fetcher"
require_relative "notion_formatter"

module Services
    module Custom
        class NotionFetcher < Fetcher

            def initialize(database_id)
                @data = []
                @connection_config = {
                    base_url: 'https://api.notion.com',
                    database_id: database_id
                }

                @formatter = Services::Custom::NotionFormatter.new
            end

            def fetch()
                # uri = URI("#{connection_config.base_url}/v1/databases/#{connection_config.database_id}")
                # response = Net::HTTP.get_response(uri)
                # formatted_response = format_response(response)
                formatted_response = [{'name' => 'name1', 'birth_date' => '12-10-1994'}]
                formatted_data = formatter.format(formatted_response)
                puts "Fetcher Response => " + formatted_data.to_s
            end

            private

            def format_response()

            end
        end
    end
end
