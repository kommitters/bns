module Services
    class BaseFetcher
        attr_reader :connection_config
        attr_reader :data
        attr_reader :formatter

        def fetch() 
            raise "Not implemented yet."
        end
    end
end
