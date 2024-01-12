# frozen_string_literal: true

require_relative "../../domain/birthday"
require_relative "../base"

module Mapper
  module Birthday
    class Notion
      include Base

      def map(data)
        data.map do |birthday|
          Domain::Birthday.new(birthday["name"], birthday["birth_date"])
        end
      end
    end
  end
end
