# coding: utf-8

# サンプルユーザー
sample_user = User.find_or_create_by(email: "sample@email.com") do |user|
  user.name = "Sample User"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = false
end

# 管理者ユーザー
admin_user = User.find_or_create_by(email: "seisaku@email.com") do |user|
  user.name = "制作ユーザー"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true
end

# サンプルタスク
if admin_user.tasks.empty?
  statuses = ["新規", "進行中", "完了"]
  priorities = ["高", "中", "低"]

  20.times do |i|
    admin_user.tasks.create!(
      title: "サンプルタスク#{i + 1}",
      description: "これはサンプルタスク#{i + 1}の説明です。タスクの詳細な内容がここに記載されます。",
      status: statuses.sample,
      priority: priorities.sample,
      due_date: Date.current + rand(1..30).days
    )
  end
end