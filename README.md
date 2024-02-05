# BNS - Business Notification System
**BNS** is a flexible solution for building your own notification use cases, connecting your datasources with your daily tools.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add bns

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install bns

## Requirements

* Ruby 3.2.2 or higher

## Building my own use case

The gem provides with basic interfaces, types, and methods to shape your own use cases in an easy way.

There are 2 currently implemented use cases:
* Birthday notifications - from Notion to Discord
* PTO notifications - from Notion to Discord

For this example we'll analize the birthday notification use case, bringing data from a notion database, and dispatching the 
notifications to a Discord channel.

A *Use Case* object, consists on 4 main componenets, having it's own responsability:

### 1. Fetcher - Obtaining the data

Specifically, a fetcher is an object in charged of bringing data from a data source. The gem already provides the base interface
for building your own fetcher for your specific data source, or rely on already built classes if they match your purpose.

The base interface for a fetcher can be found under the `bns/fetcher/base.rb` class. Since this is a implementation of the `Fetcher::Base` 
for bringing data from a Notion database, it was created on a new namespace for that data source, it can be found under
`/bns/fetcher/notion/birthday.rb`. It implements specific logic for fetching the data and validating the response.

### 2. Mapper - Shaping it

The **Mapper** responsability, is to shape the data using custom types from the app domain, bringing it into a
common structure understandable for other components, specifically the **Formatter**.

Because of the use case, the Mapper implementation for it, relyes on specific types for representing a Birthday it self. It can be found
under `/bns/mapper/notion/birthday.rb`

### 3. Formatter - Preparing the message

The **Formatter**, is in charge of preparing the message to be sent in our notification, and give it the right format with the right data.
The template or 'format' to be used should be included in the use case configurations, which we'll review in a further step. It's 
implementation can be found under `/bns/formatter/discord/birthday.rb`.

### 4. Dispatcher - Sending your notification

Finally, the **Dispatcher** basically, sends or dispatches the formatted message into a destination, since the use case was implemented for
Discord, it implements specific logic to communicate with a Discord channel using a webhook. The webhook configuration and name for the 'Sender' 
in the channel should be provided with the initial use case configurations. It can be found under `/bns/dispatcher/discord/implementation.rb`

## Examples

In this example is showed, how you can instantiate a birthdays notification use case, and execute it on a simple ruby project and using a serverless configuration
and a simple lambda deployment.

### Preparing the configurations

We'll need some configurations for this specific use case:
* A **Notion database ID**, from a database with the following structure:

| Complete Name (text) |    BD_this_year (formula)   |         BD (date)        |
| -------------------- | --------------------------- | ------------------------ |
|       John Doe       |       January 24, 2024      |      January 24, 2000    |
|       Jane Doe       |       June 20, 2024         |      June 20, 2000       |

With the following formula for the **BD_this_year** column: `dateAdd(prop("BD"), year(now()) - year(prop("BD")), "years")`

* A Notion secret, which can be obtained, by creating an integration here: `https://developers.notion.com/`, browsing on the **View my integations** option, and selecting the **New Integration** or **Create new integration** buttons.

* A webhook key, which can be generated directly on discrod on the desired channel, following this instructions: `https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks`

* A filter, to determine which data to bring from the database, for this specific case, the filter we used is:

```
#### file.rb ####
today = Date.now
{
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
```

* A template for the formatter to be used for formatting the payload to dispatch to Discord. For this specific case, the format of the messages should be:

`"NAME, Wishing you a very happy birthday! Enjoy your special day! :birthday: :gift:"`

### Instantiating the Use Case

To instantiate the use case, the `UseCases` module should provide a method for this purpose, for this specific case, the `notify_birthday_from_notion_to_discord`
is the desired one.

**Normal ruby code**
```
filter = {
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

options = {
    fetch_options: {
      base_url: "https://api.notion.com",
      database_id: NOTION_DATABASE_ID,
      secret: NOTION_API_INTEGRATION_SECRET,
      filter: filter
    },
    dispatch_options: {
      webhook: "https://discord.com/api/webhooks/1199213527672565760/KmpoIzBet9xYG16oFh8W1RWHbpIqT7UtTBRrhfLcvWZdNiVZCTM-gpil2Qoy4eYEgpdf",
      name: "Birthday Bot"
    }
}

use_case = UseCases.notify_birthday_from_notion_to_discord(options)

use_case.perform

```

**Serverles**

Examples of different use cases, and how to configure and deploy the lambdas can be found on: `https://github.com/kommitters/bns_serverless`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/business_notification_system.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
