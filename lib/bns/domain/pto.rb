# frozen_string_literal: true

module Domain
  ##
  # The Domain::Pto class provides a domain-specific representation of a Paid Time Off (PTO) object.
  # It encapsulates information about an individual's time off, including the individual's name,
  # the start date, and the end date of the time off period.
  class Pto
    attr_reader :individual_name, :start_date, :end_date

    # Initializes a Domain::Pto instance with the specified individual name, start date, and end date.
    #
    # * @param [String] individual_name Name of the individual.
    # * @param [DateTime] start_date Start day of the PTO.
    # * @param [String] end_date End date of the PTO.
    def initialize(individual_name, start_date, end_date)
      @individual_name = individual_name
      @start_date = start_date
      @end_date = end_date
    end
  end
end
