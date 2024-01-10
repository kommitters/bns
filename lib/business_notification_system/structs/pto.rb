module Structs
    class Pto
        attr_reader :individual_name
        attr_reader :start_date
        attr_reader :end_date

        def initialize(individual_name, start_date, end_date)
            @individual_name = individual_name
            @start_date = start_date
            @end_date = end_date
        end
    end
end