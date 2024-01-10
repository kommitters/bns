module Structs
    class Birthday
        attr_reader :individual_name
        attr_reader :date

        def initialize(individual_name, date)
            @individual_name = individual_name
            @date = date
        end
    end
end