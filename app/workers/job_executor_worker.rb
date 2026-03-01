class JobExecutorWorker
    include Sidekiq::Worker

    def perform(job_id)
        job = Job.find(job_id)
        return unless job.status == "queued"

        return unless ConcurrencyService.acquire(job.client_id)

        job.start!

        begin
            sleep 2
            jon.complete!
        rescue => e
            hanlde_retry(job)
        ensure
            ConcurrencyService.release(job.client_id)
        end
    end

    private

    def handle_retry(job)
        job.increment!(:retry_count)

        if job.retry_count <= 5
            delay = 2 ** job.retry_count
            job.update!(
                status: "queued",
                scheduled_at: Time.current +  delay.seconds
            )
        else
            job.fail!
        end
    end
end
