# frozen_string_literal: true

RSpec.describe Formatter::Birthday::Discord do
  before do
    @data = [Domain::Birthday.new("Jane Doe", "2024-01-11"), Domain::Birthday.new("John Doe", "2024-01-18")]
    @formatter = described_class.new
  end

  describe "attributes and arguments" do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
    it { expect(@formatter).to respond_to(:format).with(1).arguments }
  end

  describe ".format" do
    it "format the given data into a specific message" do
      formatted_message = @formatter.format(@data)

      expect(formatted_message).to be_an_instance_of(String)
    end

    it "format the given data into a specific message" do
      invalid_data = [{ name: "John Doe", birth_date: "2024-01-18" },
                      { name: "Jane Doe", birth_date: "2024-01-19" }]

      expect { @formatter.format(invalid_data) }.to raise_exception("Invalid data format")
    end
  end
end
