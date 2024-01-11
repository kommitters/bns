require_relative "../../domain/birthday"
require_relative "../base_formatter"

module Services
    module Custom
        class NotionFormatter
            include BaseFormatter

            def format(data)
                data.map do |birthday|
                    Structs::Birthday.new(birthday['individual_name'], birthday['date'])
                end

                return data
            end
        end
    end
end
