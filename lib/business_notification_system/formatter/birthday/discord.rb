require_relative "../../domain/birthday"
require_relative "../base"

module Formatter
    module Birthday
        class Discord
            include Base

            def format(data)
                template = "NAME, Wishing you a very happy birthday! Enjoy your special day! :birthday: :gift:"
                payload = ""
                
                data.each_index do |index|
                    payload += template.gsub("NAME", data[index].individual_name) + "\n"
                end

                payload
            end
        end
    end
end
