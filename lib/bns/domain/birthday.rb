# frozen_string_literal: true

module Domain
  class Birthday
    attr_reader :individual_name, :date

    def initialize(individual_name, date)
      @individual_name = individual_name
      @date = date
    end
  end
end
