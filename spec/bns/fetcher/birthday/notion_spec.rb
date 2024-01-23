# frozen_string_literal: true

RSpec.describe Fetcher::Birthday::Notion do
  before do
    @config = {
      base_url: "https://api.notion.com",
      database_id: "c17e556d16c84272beb4ee73ab709631",
      secret: "secret_BELfDH6cf4Glc9NLPLxvsvdl9iZVD4qBCyMDXqch51B",
      filter: {}
    }

    @fetcher = described_class.new(@config)
  end

  describe "attributes and arguments" do
    it { expect(@fetcher).to respond_to(:config) }

    it { expect(described_class).to respond_to(:new).with(1).arguments }
    it { expect(@fetcher).to respond_to(:fetch).with(0).arguments }
    it { expect(@fetcher).to respond_to(:normalize_response).with(1).arguments }
  end

  describe ".fetch" do
    it "fetch data from the given configured notion database" do
      VCR.use_cassette("notion_birthdays_no_filter") do
        expected = [
          { "name" => "Laura Villada", "birth_date" => "2024-01-31" },
          { "name" => "Luz Maria Quintero", "birth_date" => "2024-01-12" },
          { "name" => "Juan Hurtado", "birth_date" => "2024-01-29" },
          { "name" => "Lorenzo Zuluaga", "birth_date" => "2024-01-15" },
          { "name" => "Luis Hurtado", "birth_date" => "2024-01-15" }
        ]

        birthdays_fetcher = described_class.new(@config)
        fetched_data = birthdays_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Array)
        expect(fetched_data.length).to eq(5)
        expect(fetched_data).to match_array(expected)
      end
    end

    it "fetch data from the given configured notion database using the provided filter" do
      VCR.use_cassette("notion_birthdays_with_filter") do
        today = DateTime.now.strftime("%F").to_s

        config = @config.merge(
          {
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
          }
        )

        expected = [
          { "name" => "Luis Hurtado", "birth_date" => "2024-01-16" }
        ]

        birthdays_fetcher = described_class.new(config)
        fetched_data = birthdays_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Array)
        expect(fetched_data.length).to eq(1)
        expect(fetched_data).to match_array(expected)
      end
    end

    it "fetch empty data from the given configured notion database" do
      VCR.use_cassette("notion_birthdays_with_empty_database") do
        config = @config
        config[:database_id] = "w17e556d16c84272beb4ee73ab709639"

        birthday_fetcher = described_class.new(config)
        fetched_data = birthday_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Array)
        expect(fetched_data.length).to eq(0)
      end
    end

    it "raises an exception caused by invalid database_id provided" do
      VCR.use_cassette("notion_birthdays_with_invalid_database_id") do
        config = @config
        config[:database_id] = "a17e556d16c84272beb4ee73ab709630"
        birthday_fetcher = described_class.new(@config)

        expected_exception = "Could not find database with ID: c17e556d-16c8-4272-beb4-ee73ab709631. " \
                             "Make sure the relevant pages and databases are shared with your integration."

        expect do
          birthday_fetcher.fetch
        end.to raise_exception(expected_exception)
      end
    end

    it "raise an exception caused by invalid or incorrect api_key provided" do
      VCR.use_cassette("notion_birthdays_with_invalid_api_key") do
        config = @config
        config[:secret] = "secret_ZELfDH6cf4Glc9NLPLxvsvdl9iZVD4qBCyMDXqch51C"
        birthday_fetcher = described_class.new(config)

        expect { birthday_fetcher.fetch }.to raise_exception("API token is invalid.")
      end
    end
  end

  # Confirm if the normalize function will be part of the fetcher, or we should handle that as a separate class/module
end
