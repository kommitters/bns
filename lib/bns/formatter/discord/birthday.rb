# frozen_string_literal: true

require_relative "../../domain/birthday"
require_relative "../base"
require_relative "./exceptions/invalid_data"

module Formatter
  module Discord
    class Birthday
      include Base

      def format(data)
        raise Formatter::Discord::Exceptions::InvalidData unless data.all? do |element|
                                                                   element.is_a?(Domain::Birthday)
                                                                 end

        template = "NAME, Wishing you a very happy birthday! Enjoy your special day! :birthday: :gift:"
        payload = ""

        data.each do |birthday|
          payload += "#{template.gsub("NAME", birthday.individual_name)}\n"
        end

        payload
      end
    end
  end
end
