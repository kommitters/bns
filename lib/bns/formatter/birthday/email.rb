# frozen_string_literal: true

require_relative "../../structs/birthday"
require_relative "../base_formatter"

module Services
  module Custom
    class NotionFormatter
      include BaseFormatter

      def format(data)
        data.map do |birthday|
          Structs::Birthday.new(birthday["individual_name"], birthday["date"])
        end

        data
      end
    end
  end
end
