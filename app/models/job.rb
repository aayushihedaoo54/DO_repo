class Job < ApplicationRecord
    STATES =  %w[queued running completed failed stalled]

    validates :status, inclusion:{ in: STATES}

    scope :ready_to_run, ->{
        where(status: "queued")
        .where("scheduled_at <= ?", Time.current)
        .order(priority: :desc,created_at: :asc)
    }

    def start!
        update!(status: "running", started_at: Time.current)
    end

    def completed!
        update!(status: "completed", completed_at: Time.current)
    end

    def fail!
        update!(status: "failed", completed_at: Time.current)
    end

    def stall!
        update!(status: "stalled",completed_at: Time.current)
    end
end
