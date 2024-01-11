require_relative "../../domain/birthday"
require_relative "../base"

module Formatter
    module Birthday
        class Discord
            include Base

            def format(data)
                template = "{NAME}, Wishing you a very happy birthday! Enjoy your special day! :birthday: :gift:"
                payload = ""
                
                data.each do |birthday|
                    payload += template.gsub("{NAME}", birthday.individual_name) + '\n'
                end

                puts "Formatter Response"
                puts payload
                payload
            end
        end
    end
end
