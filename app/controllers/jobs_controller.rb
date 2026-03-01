class JobsController < ApplicationController
    def create
        job = Job.create!(
            client_id: params[:client_id],
            priority: map_priority(params[:priority]),
            status: "queued",
            scheduled_at: Time.current
        )

        render json: {job_id: job.id,status: job.status}
    end

    private

    def map_priority(p)
        {"low" => 1, "medium" => 2, "high" => 3}[p] || 1
    end
end
