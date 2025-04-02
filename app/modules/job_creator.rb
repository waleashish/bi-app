module JobCreator
    class Job
        attr_accessor :source_path, :source, :status

        def initialize(source, source_path, status)
            @source = source
            @source_path = source_path
            @status = status
        end
    end
end