# frozen_string_literal: true

RSpec.describe Formatter::Discord::PtoToday do
  before do
    @data = [
      Domain::Pto.new("Range PTO", "2024-01-11", "2024-01-13"),
      Domain::Pto.new("Time PTO", "2024-02-22T07:00:00.000-05:00", "2024-02-22T12:00:00.000-05:00"),
      Domain::Pto.new("Day PTO", "2024-01-11", "2024-01-11")
    ]
  end

  describe "attributes and arguments" do
    before { @formatter = described_class.new }

    it { expect(described_class).to respond_to(:new).with(0).arguments }
    it { expect(@formatter).to respond_to(:format).with(1).arguments }
  end

  describe ".format with custom template" do
    before do
      config = { template: ":beach: individual_name is on PTO" }
      @formatter = described_class.new(config)
    end

    it "format the given data into a specific message" do
      formatted_message = @formatter.format(@data)
      expectation = ":beach: Range PTO is on PTO from 2024-01-11 to 2024-01-13\n" \
                    ":beach: Time PTO is on PTO today from 07:00 am to 12:00 pm\n" \
                    ":beach: Day PTO is on PTO all day\n"

      expect(formatted_message).to be_an_instance_of(String)
      expect(formatted_message).to eq(expectation)
    end

    it "raises an exception when data is not Domain::Pto type" do
      invalid_data = [{ name: "John Doe", start: "2024-01-18", end: "2024-01-18" },
                      { name: "Jane Doe", start: "2024-01-19", end: "2024-01-23" }]

      expect { @formatter.format(invalid_data) }.to raise_exception(Formatter::Discord::Exceptions::InvalidData)
    end
  end
end
