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
          { "name" => "Juan Manuel Hurtado Rendon", "birth_date" => "2024-10-12" },
          { "name" => "Mario Andrés Yusti Mejía", "birth_date" => "2024-01-25" },
          { "name" => "Andrea Cuesta Tangarife", "birth_date" => "2024-08-11" },
          { "name" => "Juan Camilo Perilla Jaramillo", "birth_date" => "2024-09-04" },
          { "name" => "Jose Orlando Castro Arias", "birth_date" => "2024-12-04" },
          { "name" => "Luz Maria Quintero", "birth_date" => "2024-10-28" },
          { "name" => "Elisabet Castaño Salazar", "birth_date" => "2024-06-20" },
          { "name" => "Laura Villada", "birth_date" => "2024-08-10" },
          { "name" => "Franco Esteban Cordoba Perez", "birth_date" => "2024-05-12" },
          { "name" => "Felipe Guzmán Sierra", "birth_date" => "2024-02-03" },
          { "name" => "Juan Manuel Roa Mejía", "birth_date" => "2024-09-07" },
          { "name" => "Julián David Sánchez Gallego", "birth_date" => "2024-02-22" },
          { "name" => "Brayan Stiven Vasquez Villa", "birth_date" => "2024-07-06" },
          { "name" => "Juan Pablo Botina Carlosama", "birth_date" => "2024-11-22" },
          { "name" => "Cristhian Camilo Rodriguez Molina", "birth_date" => "2024-04-25" },
          { "name" => "Luis Felipe Tejada Padilla", "birth_date" => "2024-10-14" },
          { "name" => "Luis Humberto López", "birth_date" => "2024-12-09" },
          { "name" => "Mario Alejandro Rodríguez", "birth_date" => "2024-01-24" },
          { "name" => "Kelium Joja", "birth_date" => "2024-03-28" },
          { "name" => "Alan Gerardo Buenhombre Parra", "birth_date" => "2024-07-14" },
          { "name" => "Juan David Gaviria Agudelo", "birth_date" => "2024-12-10" },
          { "name" => "Miguel Angel Nieto Arias", "birth_date" => "2024-05-02" },
          { "name" => "Elsa Victoria Hurtado", "birth_date" => "2024-08-09" },
          { "name" => "Lorenzo Zuluaga Urrea", "birth_date" => "2024-10-12" },
          { "name" => "Peter D’loise Chicaiza Cortez", "birth_date" => "2024-06-27" },
          { "name" => "Sergio Alejandro Guerrero Ruiz", "birth_date" => "2024-02-12" },
          { "name" => "Manuela Bernal Toro", "birth_date" => "2024-08-27" }
        ]

        birthdays_fetcher = described_class.new(@config)
        fetched_data = birthdays_fetcher.fetch

        expect(fetched_data).to be_an_instance_of(Array)
        expect(fetched_data.length).to eq(27)
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
          { "name" => "Mario Alejandro Rodríguez", "birth_date" => "2024-01-24" }
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
