require 'rails_helper'

RSpec.describe "Priority Scheduling" do
  it "executes high priority first" do
    low = create(:job, priority: 1, scheduled_at: Time.current)
    high = create(:job, priority: 3, scheduled_at: Time.current)

    expect(Job.ready_to_run.first).to eq(high)
  end

  it "does not pick future jobs" do
    future_job = create(:job, scheduled_at: 2.hours.from_now)
    expect(Job.ready_to_run).not_to include(future_job)
  end
end