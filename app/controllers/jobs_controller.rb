class JobsController < ApplicationController
    before_action :set_job, only: %i[ show destroy ]

    # Get all jobs
    def index
        @jobs = Job.all
    end

    # Shows the job and its status
    def show
    end

    # Displays a form to take all the relevant fields
    def new
      @jobs = Job.new
    end

    # can map to submit button after getting all the required infor from new request
    def create
        # job_message = JobCreator::Job.new(params[:source_file])
        job_message = JobCreator::Job.new(
            params[:source],
            params[:source_file],
            params[:status]
        )
        ApplicationHelper::QueueProcessor.instance.add_to_queue(job_message)
        @job = Job.new(
            source: params[:source],
            source_file: params[:source_file],
            status: params[:status]
        )

        respond_to do |format|
            if @job.save
                format.html { redirect_to jobs_path, notice: "Job was successfully created." }
                format.json { render :show, status: :created, location: @job }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @job.errors, status: :unprocessable_entity }
            end
        end
    end

    # abort a job if it is not completed yet
    def destroy
        if @job.status != "COMPLETED"
            @job.destroy!
            respond_to do |format|
                format.html { redirect_to jobs_path, status: :see_other, notice: "Job was successfully aborted." }
                format.json { head :no_content }
            end
        else
            respond_to do |format|
                format.html { redirect_to jobs_path, status: :see_other, notice: "Job already completed. Can't abort!" }
                format.json { head :no_content }
            end
        end
    end

    # abort all those jobs which are currently not completed
    def delete_all
        @jobs = Job.all

        @jobs.each do |job|
            if job.status != "COMPLETED"
                job.destroy!
            end
        end
        respond_to do |format|
            format.html { redirect_to jobs_path, status: :see_other, notice: "All running jobs were successfully aborted." }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_job
            @job = Job.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def job_params
            params.expect(:source, :source_file, :status)
        end
end
