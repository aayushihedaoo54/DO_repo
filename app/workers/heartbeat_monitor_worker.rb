class HeartbeatMonitorWorker
    include Sidekiq::Worker

    def perform
        Job.where(status: "running").find_each do |job|
            unless Redis.new(url: "redis://127.0.0.1:6379/0").exists?("job:#{job.id}:heartbeat")
                job.stall!
            end
        end
    end
end