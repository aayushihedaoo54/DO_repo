FactoryBot.define do
  factory :client do
    client_id { "MyString" }
    concurrency_limit { 1 }
  end
end
