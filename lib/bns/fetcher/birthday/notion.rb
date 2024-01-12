require "httparty"
require 'date'

require_relative "../base"

module Fetcher
    module Birthday
        class Notion < Base
            def initialize(config)
                @config = config
            end

            def fetch()
                url = "#{config[:base_url]}/v1/databases/#{config[:database_id]}/query"
                today = DateTime.now().strftime("%F").to_s

                filter = {
                    "filter": {
                        "or": [
                            {
                                "property": "BD_this_year",
                                "date": {
                                    "equals": today
                                }
                            }
                        ]
                    },
                    "sorts": []
                }.to_json

                response = HTTParty.post(url, {
                    body: filter,
                    headers: {
                        "Authorization" => "Bearer #{config[:secret]}",
                        "Content-Type" => 'application/json',
                        "Notion-Version" => '2022-06-28'
                    }
                })

                formatted_response = format_response(response['results'])

                formatted_response
            end

            def format_response(response)
                formatted_response = []

                response.map do |value|
                    formatted_value = {}
                    properties = value['properties']
                    properties.delete('Name')

                    properties.each do |k, v|
                        if k == 'Full Name'
                            formatted_value['name'] = extract_rich_text_field_value(v)
                        else
                            formatted_value['birth_date'] = extract_date_field_value(v)
                        end
                    end

                    formatted_response.append(formatted_value)
                end

                formatted_response
            end

            private

            def extract_rich_text_field_value(data)
                data['rich_text'][0]['plain_text']
            end

            def extract_date_field_value(data)
                data['date']['start']
            end
        end
    end
end
