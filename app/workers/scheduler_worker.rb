class SchedulerWorker
    include Sidekiq::Worker
    def perform
        Job.ready_to_run.limit(10).find_each do |job|
            JobExecutorWorker.perform_async(job.id)
        end
    end
end