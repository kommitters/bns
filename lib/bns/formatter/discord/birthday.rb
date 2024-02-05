# frozen_string_literal: true

require_relative "../../domain/birthday"
require_relative "../base"
require_relative "./exceptions/invalid_data"

module Formatter
  module Discord
    ##
    # This class implementats the methods of the Formatter::Base module, specifically designed for formatting birthday
    # data in a way suitable for Discord messages.
    class Birthday
      include Base

      # Implements the logic for building a formatted payload with the given template for birthdays.
      #
      # <br>
      # <b>Params:</b>
      # * <tt>List<Domain::Birthday></tt> birthdays_list: list of mapped birthdays.
      #
      # <br>
      # <b>raises</b> <tt>Formatter::Discord::Exceptions::InvalidData</tt> when invalid data is provided.
      #
      # <br>
      # <b>returns</b> <tt>String</tt> payload: formatted payload suitable for a Discord message.
      #
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
