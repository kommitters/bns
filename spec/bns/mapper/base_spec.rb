# frozen_string_literal: true

RSpec.describe Mapper::Base do
  #   it { is_expected.to respond_to(:format).with(1).arguments }

  describe ".format" do
    let(:testing_class) { Class.new { include Mapper::Base } }

    it "provides no implementation for the method" do
      instace = testing_class.new
      data = []
      expect { instace.map(data) }.to raise_exception("Not implemented yet.")
    end
  end
end
