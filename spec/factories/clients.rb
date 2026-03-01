FactoryBot.define do
  factory :client do
    client_id { "client_id" }
    concurrency_limit { 2 }
  end
end
