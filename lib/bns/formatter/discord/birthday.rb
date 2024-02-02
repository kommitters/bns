# frozen_string_literal: true

require_relative "../../domain/birthday"
require_relative "../base"
require_relative "./exceptions/invalid_data"

module Formatter
  module Discord
    class Birthday
      include Base

      def format(birthdays_list)
        raise Formatter::Discord::Exceptions::InvalidData unless birthdays_list.all? do |brithday|
                                                                   brithday.is_a?(Domain::Birthday)
                                                                 end

        template = "NAME, Wishing you a very happy birthday! Enjoy your special day! :birthday: :gift:"
        payload = ""

        birthdays_list.each do |birthday|
          payload += "#{template.gsub("NAME", birthday.individual_name)}\n"
        end

        payload
      end
    end
  end
end
