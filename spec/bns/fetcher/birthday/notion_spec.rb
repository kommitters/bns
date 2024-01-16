# frozen_string_literal: true

RSpec.describe Fetcher::Birthday::Notion do
  before do
    @config = {
      base_url: "https://api.notion.com",
      database_id: "c17e556d16c84272beb4ee73ab709631",
      secret: "secret_BELfDH6cf4Glc9NLPLxvsvdl9iZVD4qBCyMDXqch51B"
    }

    @fetcher = described_class.new(@config)
  end

  describe "Arguments and methods" do
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
  end

  # Confirm if the normalize function will be part of the fetcher, or we should handle that as a separate class/module
end
