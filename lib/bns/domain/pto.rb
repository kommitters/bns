# frozen_string_literal: true

module Domain
  class Pto
    attr_reader :individual_name, :start_date, :end_date

    def initialize(individual_name, start_date, end_date)
      @individual_name = individual_name
      @start_date = start_date
      @end_date = end_date
    end
  end
end
