require_relative "business_notification_system/structs/birthday"

module Services
    module Custom
        class NotionFormatter
            includes Formatter

            def format(data)
                data.map do |birthday|
                    Birthday.new(birthday.individual_name, birthday.date)
                end

                return data
            end
        end