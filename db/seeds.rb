# coding: utf-8

puts "🌱 シードデータの生成を開始します..."

# 基本ユーザー（必須）
puts "📋 基本ユーザーを作成中..."

sample_user = User.find_or_create_by(email: "sample@email.com") do |user|
  user.name = "Sample User"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = false
end

admin_user = User.find_or_create_by(email: "seisaku@email.com") do |user|
  user.name = "制作ユーザー"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true
end

puts "✅ 基本ユーザー作成完了"

# 大規模データ生成（環境変数で制御）
if ENV['LARGE_DATASET'] == 'true'
  puts "🚀 大規模データセットを生成中..."

  # 100名のユーザー生成
  puts "👥 100名のユーザーを生成中..."

  # 管理者を追加で1名生成
  User.find_or_create_by(email: "admin@example.com") do |user|
    user.name = "システム管理者"
    user.password = "password"
    user.password_confirmation = "password"
    user.admin = true
  end

  # 一般ユーザー98名生成
  98.times do |i|
    email = "user#{i + 1}@example.com"
    User.find_or_create_by(email: email) do |user|
      user.name = "ユーザー#{i + 1}"
      user.password = "password"
      user.password_confirmation = "password"
      user.admin = false
    end
  end

  puts "✅ 全ユーザー生成完了 (#{User.count}名)"

  # 大量タスクデータ生成
  puts "📝 大量タスクデータを生成中..."

  statuses = ["新規", "進行中", "完了"]
  priorities = ["高", "中", "低"]

  # タスクのサンプルタイトルと説明
  task_templates = [
    { title: "プロジェクト企画書作成", description: "新規プロジェクトの企画書を作成し、関係者に共有する。" },
    { title: "クライアント打ち合わせ", description: "来週のクライアント打ち合わせの準備と資料作成を行う。" },
    { title: "システム設計書レビュー", description: "開発チームが作成したシステム設計書をレビューし、フィードバックを提供する。" },
    { title: "マーケティング戦略検討", description: "新商品のマーケティング戦略を検討し、具体的な施策を立案する。" },
    { title: "予算計画作成", description: "来年度の予算計画を作成し、各部門と調整を行う。" },
    { title: "研修資料準備", description: "新入社員向けの研修資料を準備し、プログラムを組む。" },
    { title: "品質改善提案", description: "製品の品質改善提案をまとめ、開発チームと共有する。" },
    { title: "競合他社分析", description: "競合他社の動向を分析し、戦略への影響を検討する。" },
    { title: "顧客満足度調査", description: "顧客満足度調査の実施と結果分析を行う。" },
    { title: "セキュリティ監査", description: "システムのセキュリティ監査を実施し、問題点を洗い出す。" }
  ]

  # 指定したユーザーに50タスクずつ生成
  target_users = User.where(email: ["seisaku@email.com", "user1@example.com", "user2@example.com"])

  target_users.each do |user|
    puts "  #{user.name} のタスクを生成中..."

    # 既存タスクがある場合はスキップ
    next if user.tasks.count >= 50

    50.times do |i|
      template = task_templates.sample
      user.tasks.create!(
        title: "#{template[:title]}#{i + 1}",
        description: "#{template[:description]} (タスク番号: #{i + 1})",
        status: statuses.sample,
        priority: priorities.sample,
        due_date: Date.current + rand(-30..60).days # 過去1ヶ月〜未来2ヶ月
      )
    end

    puts "    ✅ #{user.name}: #{user.tasks.count}タスク"
  end

  # 他のユーザーには1-10タスクをランダム生成
  other_users = User.where.not(email: ["seisaku@email.com", "user1@example.com", "user2@example.com", "sample@email.com"])

  puts "  その他のユーザーにランダムタスクを生成中..."

  other_users.each do |user|
    next if user.tasks.any? # 既存タスクがある場合はスキップ

    task_count = rand(1..10)
    task_count.times do |i|
      template = task_templates.sample
      user.tasks.create!(
        title: "#{template[:title]}",
        description: template[:description],
        status: statuses.sample,
        priority: priorities.sample,
        due_date: Date.current + rand(-15..45).days
      )
    end
  end

  puts "✅ 全タスク生成完了 (#{Task.count}タスク)"
  puts "🎉 大規模データセット生成完了！"

else
  # 通常のサンプルデータ（小規模）
  puts "📝 通常のサンプルタスクを生成中..."

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

    puts "✅ サンプルタスク生成完了 (#{admin_user.tasks.count}タスク)"
  else
    puts "⏭️  既存のタスクが存在するため、タスク生成をスキップしました"
  end
end

puts "🌟 シードデータ生成完了!"
puts "📊 最終統計:"
puts "   - ユーザー数: #{User.count}名"
puts "   - 管理者数: #{User.where(admin: true).count}名"
puts "   - タスク数: #{Task.count}タスク"
puts ""
puts "🔑 ログイン情報:"
puts "   管理者: seisaku@email.com / password"
puts "   一般ユーザー: sample@email.com / password"
if User.count > 10
  puts "   その他: user1@example.com / password (50タスク)"
  puts "          user2@example.com / password (50タスク)"
end