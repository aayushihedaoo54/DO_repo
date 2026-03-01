require 'rails_helper'

RSpec.describe HeartbeatMonitorWorker, type: :worker do
  let(:redis) { Redis.new(url: "redis://127.0.0.1:6379/0") }

  before do
    redis.flushdb
  end

  it "marks job stalled if no heartbeat" do
    job = create(:job, status: "running")

    HeartbeatMonitorWorker.new.perform
    job.reload

    expect(job.status).to eq("stalled")
  end

  it "does not stall job with heartbeat" do
    job = create(:job, status: "running")

    redis.set("job:#{job.id}:heartbeat", Time.current.to_i)

    HeartbeatMonitorWorker.new.perform
    job.reload

    expect(job.status).to eq("running")
  end
end