Thread.new do
    loop do
        begin
            # Blocking call: waits until a job is available.
            ApplicationHelper::QueueProcessor.instance.process_next_int_queue
            # Optional: sleep for a bit before retrying to avoid a tight loop on errors.
            sleep 1
        end
    end
end