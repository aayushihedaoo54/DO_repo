FactoryBot.define do
  factory :job do
    client_id { "client_1" }
    priority { 2 }
    status { "queued" }
    # retry_count { 1 }
    scheduled_at {Time.current}
    # completed_at { "2026-03-01 00:27:33" }
  end
end
