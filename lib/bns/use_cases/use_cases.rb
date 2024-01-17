# frozen_string_literal: true

require_relative "../fetcher/birthday/notion"
require_relative "../dispatcher/discord"
require_relative "../mapper/birthday/notion"
require_relative "../formatter/birthday/discord"
require_relative "use_case"

module UseCases
  def self.notify_birthday_from_notion_to_discord(options)
    options = {
      fetcher: Fetcher::Birthday::Notion.new(options[:fetch_options]), # !TODO: Use a class for specific configs for fetcher and dispatcher, after everything is working
      mapper: Mapper::Birthday::Notion.new,
      formatter: Formatter::Birthday::Discord.new,
      dispatcher: Dispatcher::Discord.new(options[:dispatch_options])
    }

    UseCases::UseCase.new(options)
  end

  # def notify_birthday_from_notion_to_email(options)
  #     @fetcher = Services::Custom::NotionFetcher.new(options[:fetch_options])
  #     @dispatcher = Services::Custom::EmailDispatcher.new(options[:dispatch_options])
  #     @mapper = Services::Custom::NotionBirthdaysMapper.new
  #     @formatter = Services::Custom::EmailBirthdaysFormatter.new

  #     use_case = UseCases::UseCase.new(fetcher, dispatcher, mapper, formatter)
  # end
end
