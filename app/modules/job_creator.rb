module JobCreator
    class Job
        attr_accessor :source_path

        def initialize(source_path)
            @source_path = source_path
        end
    end
end