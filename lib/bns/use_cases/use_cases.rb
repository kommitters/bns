# frozen_string_literal: true

require_relative "../fetcher/notion/birthday"
require_relative "../mapper/notion/birthday"
require_relative "../formatter/discord/birthday"

require_relative "../fetcher/notion/pto"
require_relative "../mapper/notion/pto"
require_relative "../formatter/discord/pto"

require_relative "../dispatcher/discord/implementation"
require_relative "use_case"

module UseCases
  def self.notify_birthday_from_notion_to_discord(options)
    options = {
      # !TODO: Use a class for specific configs for fetcher and dispatcher, after everything is working
      fetcher: Fetcher::Notion::Birthday.new(options[:fetch_options]),
      mapper: Mapper::Notion::Birthday.new,
      formatter: Formatter::Discord::Birthday.new,
      dispatcher: Dispatcher::Discord::Implementation.new(options[:dispatch_options])
    }

    UseCases::UseCase.new(options)
  end

  def self.notify_pto_from_notion_to_discord(options)
    options = {
      # !TODO: Use a class for specific configs for fetcher and dispatcher, after everything is working
      fetcher: Fetcher::Notion::Pto.new(options[:fetch_options]),
      mapper: Mapper::Notion::Pto.new,
      formatter: Formatter::Discord::Pto.new,
      dispatcher: Dispatcher::Discord::Implementation.new(options[:dispatch_options])
    }

    UseCases::UseCase.new(options)
  end
end
