# frozen_string_literal: true

RSpec.describe Formatter::Base do
  describe ".format" do
    let(:testing_class) { Class.new { include Formatter::Base } }

    it "provides no implementation for the method" do
      instace = testing_class.new
      data = []
      expect { instace.format(data) }.to raise_exception(Exceptions::FunctionNotImplemented)
    end
  end
end
