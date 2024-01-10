require_relative "../../structs/birthday"
require_relative "../formatter"

module Services
    module Custom
        class NotionFormatter
            include Formatter

            def format(data)
                data.map do |birthday|
                    Structs::Birthday.new(birthday['individual_name'], birthday['date'])
                end

                return data
            end
        end
    end
end
