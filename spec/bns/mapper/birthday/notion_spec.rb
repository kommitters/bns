# frozen_string_literal: true

RSpec.describe Mapper::Birthday::Notion do
  before do
    @data = [{ name: "Jane Doe", birth_date: "2024-01-11" }, { name: "Jhon Doe", birth_date: "2024-01-11" }]
    @mapper = described_class.new
  end

  describe "attributes and arguments" do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
    it { expect(@mapper).to respond_to(:map).with(1).arguments }
  end

  describe ".format" do
    it "maps the given data into a domain specific one" do
      mapped_data = @mapper.map(@data)

      are_birthdays = mapped_data.all? { |element| element.is_a?(Domain::Birthday) }

      expect(mapped_data).to be_an_instance_of(Array)
      expect(mapped_data.length).to eq(2)
      expect(are_birthdays).to be_truthy
    end
  end
end
