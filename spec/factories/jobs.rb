FactoryBot.define do
  factory :job do
    client_id { "MyString" }
    priority { 1 }
    status { "MyString" }
    retry_count { 1 }
    scheduled_at { "2026-03-01 00:27:33" }
    completed_at { "2026-03-01 00:27:33" }
  end
end
