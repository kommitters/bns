# frozen_string_literal: true

RSpec.describe Formatter::Slack::PtoToday do
  before do
    @data = [
      Domain::Pto.new("user1", "2024-02-15 16:00:00-05", "2024-02-15 17:00:00-05"),
      Domain::Pto.new("user2", "2024-02-14 00:00:00-05", "2024-02-16 23:59:59-05"),
      Domain::Pto.new("user3", "2024-02-19 00:00:00-05", "2024-02-19 00:00:00-05")
    ]
  end

  describe "attributes and arguments" do
    before { @formatter = described_class.new }

    it { expect(described_class).to respond_to(:new).with(1).arguments }
    it { expect(@formatter).to respond_to(:format).with(1).arguments }
  end

  describe ".format with custom template" do
    before do
      config = {
        template: ":beach: individual_name is on PTO",
        timezone: "-05:00"
      }

      @formatter = described_class.new(config)
    end

    it "format the given data into a specific message" do
      formatted_message = @formatter.format(@data)
      expectation = ":beach: user1 is on PTO today from 04:00 pm to 05:00 pm\n" \
                    ":beach: user2 is on PTO from 2024-02-14 to 2024-02-16\n" \
                    ":beach: user3 is on PTO all day\n"

      expect(formatted_message).to be_an_instance_of(String)
      expect(formatted_message).to eq(expectation)
    end

    it "raises an exception when data is not Domain::Pto type" do
      invalid_data = [{ name: "John Doe", start: "2024-01-18", end: "2024-01-18" },
                      { name: "Jane Doe", start: "2024-01-19", end: "2024-01-23" }]

      expect { @formatter.format(invalid_data) }.to raise_exception(Formatter::Slack::Exceptions::InvalidData)
    end
  end
end
