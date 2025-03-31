class ApplicationController < ActionController::Base
  before_action :data_gathering_params, only: %i[add_data_gathering_job]

  def add_data_gathering_job(params)
    # Create a job of gathering data from the source files and push it to the queue
    job = JobCreator::Job.new(params[:path])
    ApplicationHelper::QueueProcessor.instance.add_to_queue(job)
  end

  def delete_all_native_objects
    NativeObject.destroy_all
  end

  private
    def data_gathering_params
      params.require(:path)
    end
end
