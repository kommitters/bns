# frozen_string_literal: true

require_relative "../fetcher/notion/birthday"
require_relative "../mapper/notion/birthday"
require_relative "../formatter/discord/birthday"

require_relative "../fetcher/notion/pto"
require_relative "../mapper/notion/pto"
require_relative "../formatter/discord/pto"

require_relative "../dispatcher/discord/implementation"
require_relative "use_case"
require_relative "./types/config"

##
# This module provides factory methods for use cases within the system. Each method
# represents a use case implementation introduced in the system.
module UseCases
  # Method intended to instantiate the following use case:
  # Birthdays notifications from Notion to Discord.
  def self.notify_birthday_from_notion_to_discord(options)
    fetcher = Fetcher::Notion::Birthday.new(options[:fetch_options])
    mapper = Mapper::Notion::Birthday.new
    formatter = Formatter::Discord::Birthday.new
    dispatcher = Dispatcher::Discord::Implementation.new(options[:dispatch_options])
    use_case_cofig = UseCases::Types::Config.new(fetcher, mapper, formatter, dispatcher)

    UseCases::UseCase.new(use_case_cofig)
  end

  # Method intended to instantiate the following use case:
  # PTO's notifications from Notion to Discord.
  def self.notify_pto_from_notion_to_discord(options)
    fetcher = Fetcher::Notion::Pto.new(options[:fetch_options])
    mapper = Mapper::Notion::Pto.new
    formatter = Formatter::Discord::Pto.new
    dispatcher = Dispatcher::Discord::Implementation.new(options[:dispatch_options])
    use_case_cofig = UseCases::Types::Config.new(fetcher, mapper, formatter, dispatcher)

    UseCases::UseCase.new(use_case_cofig)
  end
end
