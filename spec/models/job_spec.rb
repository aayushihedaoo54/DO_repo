require 'rails_helper'

RSpec.describe Job, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:job)).to be_valid
    end

    it "is invalid with invalid status" do
      job = build(:job, status: "random")
      expect(job).not_to be_valid
    end
  end

  describe "state transitions" do
    let(:job) { create(:job, status: "queued") }

    it "transitions queued -> running" do
      job.start!
      expect(job.status).to eq("running")
      expect(job.started_at).not_to be_nil
    end

    it "transitions running -> completed" do
      job.start!
      job.complete!
      expect(job.status).to eq("completed")
      expect(job.completed_at).not_to be_nil
    end

    it "transitions running -> failed" do
      job.start!
      job.fail!
      expect(job.status).to eq("failed")
    end

    it "transitions running -> stalled" do
      job.start!
      job.stall!
      expect(job.status).to eq("stalled")
    end
  end
end
