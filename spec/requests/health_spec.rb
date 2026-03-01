require 'rails_helper'

RSpec.describe "Health API", type: :request do
  it "returns 200 when healthy" do
    get "/health/detailed"
    expect(response).to have_http_status(:ok)
  end

  it "returns structured json" do
    get "/health/detailed"
    body = JSON.parse(response.body)

    expect(body).to have_key("database")
    expect(body).to have_key("redis")
    expect(body).to have_key("queue_latency")
  end
end