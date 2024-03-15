# frozen_string_literal: true

RSpec.describe Mapper::Imap::SupportEmails do
  let(:sender) { [{ "mailbox" => "user", "host" => "gmail.com" }] }
  let(:emails) { [double("email", date: Date.today, subject: "subject", sender: sender)] }

  before do
    @imap_response = Fetcher::Imap::Types::Response.new(emails)
    @mapper = described_class.new
  end

  describe "attributes and arguments" do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
    it { expect(@mapper).to respond_to(:map).with(1).arguments }
  end

  describe ".map" do
    it "maps the given data into an array of Domain::SupportEmail instances" do
      mapped_data = @mapper.map(@imap_response)

      are_emails = mapped_data.all? { |element| element.is_a?(Domain::SupportEmail) }

      expect(mapped_data).to be_an_instance_of(Array)
      expect(mapped_data.length).to eq(1)
      expect(are_emails).to be_truthy
    end
  end
end
