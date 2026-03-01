require 'rails_helper'

RSpec.describe ConcurrencyService do
#   before { Redis.current.flushdb }
  before { ConcurrencyService.redis.flushdb }

  let!(:client) { create(:client, concurrency_limit: 1) }

  it "allows job if under limit" do
    expect(ConcurrencyService.acquire(client.client_id)).to be true
  end

  it "blocks job if over limit" do
    ConcurrencyService.acquire(client.client_id)
    expect(ConcurrencyService.acquire(client.client_id)).to be false
  end

  it "releases slot properly" do
    ConcurrencyService.acquire(client.client_id)
    ConcurrencyService.release(client.client_id)

    expect(ConcurrencyService.acquire(client.client_id)).to be true
  end

  it "retry does not bypass concurrency quota" do
    client = create(:client, client_id: "client_1", concurrency_limit: 1)
    job = create(:job, client_id: client.client_id)

    ConcurrencyService.acquire(client.client_id)

    expect(ConcurrencyService.acquire(client.client_id)).to be false
  end

end