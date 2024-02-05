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
#
module UseCases
  # Provides an instance of the Birthdays notifications from Notion to Discord use case implementation.
  #
  # <b>Example</b>
  #
  #  "filter": {
  #    "or": [
  #        {
  #         "property": "BD_this_year",
  #         "date": {
  #          "equals": today
  #         }
  #        }
  #       ]
  #     },
  #    "sorts": []
  #   }
  #
  #   options = {
  #     fetch_options: {
  #       base_url: "https://api.notion.com",
  #       database_id: NOTION_DATABASE_ID,
  #       secret: NOTION_API_INTEGRATION_SECRET,
  #       filter: filter
  #     },
  #     dispatch_options: {
  #       webhook: "https://discord.com/api/webhooks/1199213527672565760/KmpoIzBet9xYG16oFh8W1RWHbpIqT7UtTBRrhfLcvWZdNiVZCTM-gpil2Qoy4eYEgpdf",
  #       name: "Birthday Bot"
  #     }
  #   }
  #
  #   use_case = UseCases.notify_birthday_from_notion_to_discord(options)
  #   use_case.perform
  #
  #   #################################################################################
  #
  #   Requirements:
  #   * Notion database ID, from a database with the following structure:
  #
  #         _________________________________________________________________________________
  #         | Complete Name (text) |    BD_this_year (formula)   |         BD (date)        |
  #         | -------------------- | --------------------------- | ------------------------ |
  #         |       John Doe       |       January 24, 2024      |      January 24, 2000    |
  #         |       Jane Doe       |       June 20, 2024         |      June 20, 2000       |
  #         ---------------------------------------------------------------------------------
  #         With the following formula for the BD_this_year column:
  #            dateAdd(prop("BD"), year(now()) - year(prop("BD")), "years")
  #
  #   * A Notion secret, which can be obtained, by creating an integration here: `https://developers.notion.com/`,
  #     browsing on the <View my integations> option, and selecting the <New Integration> or <Create new>
  #     integration** buttons.
  #   * A webhook key, which can be generated directly on discrod on the desired channel, following this instructions:
  #     https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
  #
  def self.notify_birthday_from_notion_to_discord(options)
    fetcher = Fetcher::Notion::Birthday.new(options[:fetch_options])
    mapper = Mapper::Notion::Birthday.new
    formatter = Formatter::Discord::Birthday.new
    dispatcher = Dispatcher::Discord::Implementation.new(options[:dispatch_options])
    use_case_cofig = UseCases::Types::Config.new(fetcher, mapper, formatter, dispatcher)

    UseCases::UseCase.new(use_case_cofig)
  end

  # Provides an instance of the PTO notifications from Notion to Discord use case implementation.
  #
  # <br>
  # <b>Example</b>
  #
  #   "filter": {
  #     "and": [
  #       {
  #         property: "Desde?",
  #         date: {
  #           "on_or_before": today
  #         }
  #       },
  #       {s
  #         property: "Hasta?",
  #         date: {
  #           "on_or_after": today
  #         }
  #       }
  #      ]
  #    },
  #    "sorts": []
  #   }
  #
  #   options = {
  #     fetch_options: {
  #       base_url: "https://api.notion.com",
  #       database_id: NOTION_DATABASE_ID,
  #       secret: NOTION_API_INTEGRATION_SECRET,
  #       filter: filter
  #     },
  #     dispatch_options: {
  #       webhook: "https://discord.com/api/webhooks/1199213527672565760/KmpoIzBet9xYG16oFh8W1RWHbpIqT7UtTBRrhfLcvWZdNiVZCTM-gpil2Qoy4eYEgpdf",
  #       name: "Pto Bot"
  #     }
  #   }
  #
  #   use_case = UseCases.notify_pto_from_notion_to_discord(options)
  #   use_case.perform
  #
  #   #################################################################################
  #
  #   Requirements:
  #   * Notion database ID, from a database with the following structure:
  #
  #         ________________________________________________________________________________________________________
  #         |    Person (person)   |        Desde? (date)                    |       Hasta? (date)                  |
  #         | -------------------- | --------------------------------------- | ------------------------------------ |
  #         |       John Doe       |       January 24, 2024                  |      January 27, 2024                |
  #         |       Jane Doe       |       November 11, 2024 2:00 PM         |      November 11, 2024 6:00 PM       |
  #         ---------------------------------------------------------------------------------------------------------
  #
  #   * A Notion secret, which can be obtained, by creating an integration here: `https://developers.notion.com/`,
  #     browsing on the <View my integations> option, and selecting the <New Integration> or <Create new>
  #     integration** buttons.
  #   * A webhook key, which can be generated directly on discrod on the desired channel, following this instructions:
  #     https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
  #
  def self.notify_pto_from_notion_to_discord(options)
    fetcher = Fetcher::Notion::Pto.new(options[:fetch_options])
    mapper = Mapper::Notion::Pto.new
    formatter = Formatter::Discord::Pto.new
    dispatcher = Dispatcher::Discord::Implementation.new(options[:dispatch_options])
    use_case_cofig = UseCases::Types::Config.new(fetcher, mapper, formatter, dispatcher)

    UseCases::UseCase.new(use_case_cofig)
  end
end
