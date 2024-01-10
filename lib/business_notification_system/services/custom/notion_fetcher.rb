require 'uri'
require 'net/http'

module Services
    module CustomServices
        class NotionFetcher < Fetcher

            def initialize(database_id)
                @data = []
                @connection_config = {
                    base_url: 'https://api.notion.com',
                    database_id: database_id
                }

                @formatter = NotionFormatter.new
            end

            def fetch()
                # uri = URI("#{connection_config.base_url}/v1/databases/#{connection_config.database_id}")
                # response = Net::HTTP.get_response(uri)
                # data = format_response(response)
                data = [{'name' => 'name1', 'birth_date' => '12-10-1994'}]
                formatted_data = formatter.format(data)
                puts "Fetcher Response => " = formatted_data
            end

            private

            def format_response()

            end
        end
    end
end