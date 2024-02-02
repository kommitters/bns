# frozen_string_literal: true

RSpec.describe Fetcher::Notion::Pto do
  before do
    @config = {
      base_url: "https://api.notion.com",
      database_id: "b68d11061aad43bd89f8f525ede2b598",
      secret: "secret_ZELfDH6cf4Glc9NLPLxvsvdl9iZVD4qBCyMDXqch51C",
      filter: {}
    }

    @fetcher = described_class.new(@config)
  end

  describe "attributes and arguments" do
    it { expect(@fetcher).to respond_to(:config) }

    it { expect(described_class).to respond_to(:new).with(1).arguments }
    it { expect(@fetcher).to respond_to(:fetch).with(0).arguments }
  end

  describe ".fetch" do
    it "fetch data from the given configured notion database" do
      VCR.use_cassette("/notion/ptos/fetch_without_filter") do
        pto_fetcher = described_class.new(@config)
        fetched_data = pto_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Fetcher::Notion::Types::Response)
        expect(fetched_data.results).to be_an_instance_of(Array)
        expect(fetched_data.results.length).to eq(7)
      end
    end

    it "fetch data from the given configured notion database using the provided filter" do
      VCR.use_cassette("/notion/ptos/fetch_with_filter") do
        config = @config.merge(
          filter: {
            "filter": {
              "and": [
                {
                  property: "Desde?",
                  date: {
                    "on_or_before": "2024-01-24"
                  }
                },
                {
                  property: "Hasta?",
                  date: {
                    "on_or_after": "2024-01-24"
                  }
                }
              ]
            },
            "sorts": []
          }
        )

        pto_fetcher = described_class.new(config)
        fetched_data = pto_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Fetcher::Notion::Types::Response)
        expect(fetched_data.results).to be_an_instance_of(Array)
        expect(fetched_data.results.length).to eq(3)
      end
    end

    it "fetch empty data from the given configured notion database" do
      VCR.use_cassette("/notion/ptos/fetch_with_empty_database") do
        config = @config
        config[:database_id] = "86772de276d24ed986713640919edf96"

        pto_fetcher = described_class.new(config)
        fetched_data = pto_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Fetcher::Notion::Types::Response)
        expect(fetched_data.results).to be_an_instance_of(Array)
        expect(fetched_data.results.length).to eq(0)
      end
    end

    it "raises an exception caused by invalid database_id provided" do
      VCR.use_cassette("/notion/ptos/fetch_with_invalid_database_id") do
        config = @config
        config[:database_id] = "b68d11061aad43bd89f8f525ede2b598"
        pto_fetcher = described_class.new(config)

        expect do
          pto_fetcher.fetch
        end.to raise_exception("Could not find database with ID: b68d1106-1aad-43bd-89f8-f525ede2b598. Make sure the relevant pages and databases are shared with your integration.")
      end
    end

    it "raises an exception caused by invalid or incorrect api_key provided" do
      VCR.use_cassette("/notion/ptos/fetch_with_invalid_api_key") do
        config = @config
        config[:secret] = "secret_ZELfDH6cf4Glc9NLPLxvsvdl9iZVD4qBCyMDXqch51C"
        pto_fetcher = described_class.new(config)

        expect { pto_fetcher.fetch }.to raise_exception("API token is invalid.")
      end
    end
  end
end
