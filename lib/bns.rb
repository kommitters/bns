# frozen_string_literal: true

require_relative "bns/version"
require_relative "bns/use_cases/use_cases"

module Bns
  include UseCases
  class Error < StandardError; end

  today = DateTime.now.strftime("%F").to_s

  options = {
    fetch_options: {
      base_url: "https://api.notion.com",
      database_id: "NOTION_DATABASE_ID",
      secret: "NOTION_SECRET",
      filter: {
        "filter": {
          "or": [
            {
              "property": "BD_this_year",
              "date": {
                "equals": today
              }
            }
          ]
        },
        "sorts": []
      }
    },
    dispatch_options: {
      webhook: "WEBHOOK_URL",
      name: "BOT_NAME"
    }
  }

  use_case = UseCases.notify_birthday_from_notion_to_discord(options)

  use_case.perform
end
