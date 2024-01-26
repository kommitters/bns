# frozen_string_literal: true

require_relative "../../domain/birthday"
require_relative "../base"

module Formatter
  module Discord
    class Birthday
      include Base

      def format(data)
        # !TODO create exception
        raise "Invalid data format" unless data.all? { |element| element.is_a?(Domain::Birthday) }

        template = "NAME, Wishing you a very happy birthday! Enjoy your special day! :birthday: :gift:"
        payload = ""

        data.each do |birthday|
          payload += "#{template.gsub("NAME", birthday.individual_name)}\n"
        end

        payload
      rescue ArgumentError => e
        puts "Formatter::Birthday::Notion Error: #{e.message}"
      end
    end
  end
end
