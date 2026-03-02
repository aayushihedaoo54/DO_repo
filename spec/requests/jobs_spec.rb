require 'rails_helper'

RSpec.describe "Jobs API", type: :request do
  it "creates job in queued state" do
    post "/jobs", params: {
      client_id: "client_1",
      priority: "high",
      workload: "task_123"
    }

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["status"]).to eq("queued")
    expect(Job.last.priority).to eq(3)
  end

  it "returns job id immediately" do
    post "/jobs", params: { client_id: "client_1", priority: "low" }

    body = JSON.parse(response.body)
    expect(body["job_id"]).to be_present
  end
end