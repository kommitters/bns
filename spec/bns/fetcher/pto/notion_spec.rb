# frozen_string_literal: true

RSpec.describe Fetcher::Pto::Notion do
  # DATABASE ID
  # real: b68d11061aad43bd89f8f525ede2b567
  # readonly: 86772de276d24ed986713640919edf96
  # fake: b68d11061aad43bd89f8f525ede2b598

  # NOTON API
  # real: secret_4x5x2CH9WKwhnptlUIJfI211CGyTTcgkjjcbr3AAO1q
  # fake: secret_4x5x2CH9WKwhnptlUIJfI211CGyTTcgkjjcbr3AAO2w

  before do
    @config = {
      base_url: "https://api.notion.com",
      database_id: "b68d11061aad43bd89f8f525ede2b598",
      secret: "secret_4x5x2CH9WKwhnptlUIJfI211CGyTTcgkjjcbr3AAO2w",
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
      VCR.use_cassette("notion_pto_no_filter") do
        expected = [
          { "name" => "Lorenzo Zuluaga", "start" => "2024-01-22", "end" => nil },
          { "name" => "Felipe Guzmán", "start" => "2023-01-22", "end" => nil },
          { "name" => "Lorenzo Zuluaga", "start" => "2024-01-20T00:00:00.000-05:00",
            "end" => "2024-01-20T15:00:00.000-05:00" },
          { "name" => "Lorenzo Zuluaga", "start" => "2024-01-29", "end" => nil },
          { "name" => "Felipe Guzmán", "start" => "2024-01-22", "end" => "2024-01-25" }
        ]

        birthdays_fetcher = described_class.new(@config)
        fetched_data = birthdays_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Array)
        expect(fetched_data.length).to eq(5)
        expect(fetched_data).to match_array(expected)
      end
    end

    it "fetch data from the given configured notion database using the provided filter" do
      VCR.use_cassette("notion_pto_with_filter") do
        today = Date.today

        config = @config.merge(
          {
            filter: {
              "filter": {
                "and": [
                  {
                    property: "Today?",
                    formula: {
                      "checkbox": { equals: true }
                    }
                  }
                ]
              },
              "sorts": []
            }
          }
        )

        expected = [
          { "name" => "Felipe Guzmán", "start" => "2024-01-22", "end" => "2024-01-25" }
        ]

        pto_fetcher = described_class.new(config)
        fetched_data = pto_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Array)
        expect(fetched_data.length).to eq(1)
        expect(fetched_data).to match_array(expected)
      end
    end

    it "fetch empty data from the given configured notion database" do
      VCR.use_cassette("notion_pto_with_empty_database") do
        config = @config
        config[:database_id] = "86772de276d24ed986713640919edf96"

        pto_fetcher = described_class.new(config)
        fetched_data = pto_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Array)
        expect(fetched_data.length).to eq(0)
      end
    end

    it "raises an exception caused by invalid database_id provided" do
      VCR.use_cassette("notion_pto_with_invalid_database_id") do
        config = @config
        config[:database_id] = "b68d11061aad43bd89f8f525ede2b598"
        pto_fetcher = described_class.new(config)

        expect do
          pto_fetcher.fetch
        end.to raise_exception("Could not find database with ID: b68d1106-1aad-43bd-89f8-f525ede2b598. Make sure the relevant pages and databases are shared with your integration.")
      end
    end

    it "raises an exception caused by invalid or incorrect api_key provided" do
      VCR.use_cassette("notion_pto_with_invalid_api_key") do
        config = @config
        config[:secret] = "secret_ZELfDH6cf4Glc9NLPLxvsvdl9iZVD4qBCyMDXqch51C"
        pto_fetcher = described_class.new(config)

        expect { pto_fetcher.fetch }.to raise_exception("API token is invalid.")
      end
    end
  end

  # Confirm if the normalize function will be part of the fetcher, or we should handle that as a separate class/module
end
