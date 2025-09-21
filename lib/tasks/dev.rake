namespace :dev do
  desc "開発環境の初期セットアップ（DBマイグレーション＋シード実行）"
  task setup: :environment do
    puts "🔧 開発環境セットアップを開始します..."

    # マイグレーション実行
    puts "📊 データベースマイグレーションを実行中..."
    Rake::Task['db:migrate'].invoke

    # シード実行（ユーザーが存在しない場合のみ）
    if User.count == 0
      puts "👤 ユーザーデータが存在しないため、シードを実行します..."
      Rake::Task['db:seed'].invoke
      puts "✅ シードデータを作成しました"
    else
      puts "✅ ユーザーデータは既に存在します（#{User.count}人）"
    end

    puts "🎉 開発環境セットアップが完了しました！"
    puts ""
    puts "📝 ログイン情報："
    puts "   Email: test@example.com"
    puts "   Password: password"
  end

  desc "開発環境のリセット（DB削除→再作成→マイグレーション→シード）"
  task reset: :environment do
    puts "🗑️  開発環境をリセットします..."

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke

    puts "🎉 開発環境のリセットが完了しました！"
  end
end