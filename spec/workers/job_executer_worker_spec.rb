require 'rails_helper'

RSpec.describe JobExecutorWorker, type: :worker do
  let(:job) { create(:job, retry_count: 0, status: "queued") }

  it "increments retry count" do
    worker = JobExecutorWorker.new
    worker.send(:handle_retry, job)

    job.reload
    expect(job.retry_count).to eq(1)
  end

  it "fails after max retries" do
    job.update(retry_count: 5)

    worker = JobExecutorWorker.new
    worker.send(:handle_retry, job)

    job.reload
    expect(job.status).to eq("failed")
  end
end