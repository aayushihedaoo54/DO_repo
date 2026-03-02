FactoryBot.define do
  factory :job do
    client_id { "client_1" }
    priority { 2 }
    workload { "task_1" }
    status { "queued" }
    scheduled_at {Time.current}
  end
end
