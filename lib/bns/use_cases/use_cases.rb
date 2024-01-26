# frozen_string_literal: true

require_relative "../fetcher/notion/birthday"
require_relative "../mapper/notion/birthday"
require_relative "../formatter/discord/birthday"

require_relative "../dispatcher/discord"
require_relative "use_case"

module UseCases
  def self.notify_birthday_from_notion_to_discord(options)
    options = {
      # !TODO: Use a class for specific configs for fetcher and dispatcher, after everything is working
      fetcher: Fetcher::Notion::Birthday.new(options[:fetch_options]),
      mapper: Mapper::Notion::Birthday.new,
      formatter: Formatter::Discord::Birthday.new,
      dispatcher: Dispatcher::Discord.new(options[:dispatch_options])
    }

    UseCases::UseCase.new(options)
  end

  def self.notify_pto_from_notion_to_discord(options)
    options = {
      fetcher: Fetcher::Pto::Notion.new(options[:fetch_options]),
      mapper: Mapper::Pto::Notion.new,
      formatter: Formatter::Pto::Discord.new,
      dispatcher: Dispatcher::Discord.new(options[:dispatch_options])
    }

    UseCases::UseCase.new(options)
  end
end
