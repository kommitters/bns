# frozen_string_literal: true

RSpec.describe Mapper::Pto::Notion do
  before do
    @data = [{ "name" => "Range PTO", "start" => "2024-01-11", "to" => "2024-01-13" },
             { "name" => "Time PTO", "start" => "2024-01-20T00:00:00.000-05:00",
               "to" => "2024-01-20T15:00:00.000-05:00" },
             { "name" => "Day PTO", "start" => "2024-01-11", "to" => nil }]
    @mapper = described_class.new
  end

  describe "attributes and arguments" do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
    it { expect(@mapper).to respond_to(:map).with(1).arguments }
  end

  describe ".format" do
    it "maps the given data into a domain specific one" do
      mapped_data = @mapper.map(@data)

      are_ptos = mapped_data.all? { |element| element.is_a?(Domain::Pto) }

      expect(mapped_data).to be_an_instance_of(Array)
      expect(mapped_data.length).to eq(3)
      expect(are_ptos).to be_truthy
    end
  end
end
