require_relative "../../domain/birthday"
require_relative "../base"

module Mapper
    module Birthday
        class Notion
            include Base

            def map(data)
                mapped_data = data.map do |birthday|
                    Domain::Birthday.new(birthday['name'], birthday['birth_date'])
                end

                puts "Mapper Response"
                puts mapped_data

                mapped_data
            end
        end
    end
end
