FactoryBot.define do
  factory :task do
    title { "サンプルタスク" }
    description { "サンプルの説明文" }
    status { "新規" }
    priority { "中" }
    due_date { 1.week.from_now }
    association :user
  end
end