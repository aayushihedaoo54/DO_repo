# require 'rails_helper'

# RSpec.describe "Jobs API", type: :request do
#   # describe "GET /index" do
#   #   pending "add some examples (or delete) #{__FILE__}"
#   # end

#   it "creates job" do 
#     post "/jobs", params: {
#       client_id: "client_1",
#       priority: "high"
#     }

#     expect(response).to have_http_status(200)
#     expect(JSON.parse(response.body)["status"]).to eq("queued")
#   end
# end

require 'rails_helper'

RSpec.describe "Jobs API", type: :request do
  it "creates job in queued state" do
    post "/jobs", params: {
      client_id: "client_1",
      priority: "high",
      workload: "task_1"
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