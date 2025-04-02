require "singleton"

module ApplicationHelper
    class QueueProcessor
        include Singleton

        def initialize
            @queue = Queue.new
        end

        def is_queue_empty?
            @queue.empty?
        end

        def add_to_queue(job)
            @queue << job
        end

        def process_next_in_queue
            # get the next job
            job = @queue.pop
            ApplicationHelper.add_to_db(job)
            rescue StandardError => e
                Rails.logger.error("Error processing job: #{e.message}")
        end
    end

    def self.add_to_db(job)
        path = job.source_path
        ext = path.split(".")[1]

        @job = Job.create(ext, path, "QUEUED")
        @job.status = "IN-PROGRESS"
        errors_occured = false
        case ext
        when "csv"
            errors_occured = NativeObjectsHelper.load_native_objects_data_from_csv(path)
        when "json"
            errors_occured = NativeObjectsHelper.load_native_objects_data_from_json(path)
        else
            raise "Unsupported file extension: #{ext}"
        end

        if errors_occured
            @job.status = "FAILED"
        else
            @job.status = "COMPLETED"
        end
    end
end
