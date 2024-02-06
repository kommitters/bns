# BNS - Business Notification System

The business notification system is designed to be a versatile platform, offering key components for building various use cases. It provides an easy-to-use tool for implementing notifications without excessive complexity.

![Build Badge](https://img.shields.io/github/actions/workflow/status/kommitters/bns/ci.yml?branch=project-opensource-config&style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/bns?style=for-the-badge)](https://coveralls.io/github/kommitters/bns?branch=main)
[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/kommitters/bns?style=for-the-badge)](https://api.securityscorecards.dev/projects/github.com/kommitters/bns)
![GitHub License](https://img.shields.io/github/license/kommitters/bns?style=for-the-badge)

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

In this example, we demonstrate how to instantiate a birthday notification use case and execute it in a basic Ruby project. We'll also cover its deployment in a serverless configuration, specifically using a simple Lambda deployment.

### Preparing the configurations

We'll need some configurations for this specific use case:
* A **Notion database ID**, from a database with the following structure:

| Complete Name (text) |    BD_this_year (formula)   |         BD (date)        |
| -------------------- | --------------------------- | ------------------------ |
|       John Doe       |       January 24, 2024      |      January 24, 2000    |
|       Jane Doe       |       June 20, 2024         |      June 20, 2000       |

With the following formula for the **BD_this_year** column: `dateAdd(prop("BD"), year(now()) - year(prop("BD")), "years")`

* A Notion secret, which can be obtained, by creating an integration here: `https://developers.notion.com/`, browsing on the **View my integations** option, and selecting the **New Integration** or **Create new integration** buttons.

* A webhook key, which can be generated directly on discord on the desired channel, following this instructions: `https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks`

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

**Serverless**

Examples of different use cases, and how to configure and deploy the lambdas can be found on: `https://github.com/kommitters/bns_serverless`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Changelog

Features and bug fixes are listed in the [CHANGELOG][changelog] file.

## Code of conduct

We welcome everyone to contribute. Make sure you have read the [CODE_OF_CONDUCT][coc] before.

## Contributing

For information on how to contribute, please refer to our [CONTRIBUTING][contributing] guide.

## License

The gem is is licensed under an MIT license. See [LICENSE][license] for details.

<br/>

<hr/>

[<img src="https://github.com/kommitters/chaincerts-smart-contracts/assets/1649973/d60d775f-166b-4968-89b6-8be847993f8c" width="80px" alt="kommit"/>](https://kommit.co)

<sub>

[Website][kommit-website] •
[Github][kommit-github] •
[X][kommit-x] •
[LinkedIn][kommit-linkedin]

</sub>

[license]: https://github.com/kommitters/bns/blob/main/LICENSE
[coc]: https://github.com/kommitters/bns/blob/main/CODE_OF_CONDUCT.md
[changelog]: https://github.com/kommitters/bns/blob/main/CHANGELOG.md
[contributing]: https://github.com/kommitters/bns/blob/main/CONTRIBUTING.md
[kommit-website]: https://kommit.co
[kommit-github]: https://github.com/kommitters
[kommit-x]: https://twitter.com/kommitco
[kommit-linkedin]: https://www.linkedin.com/company/kommit-co
