# coding: utf-8

namespace :data do
  desc "通常のサンプルデータを生成"
  task seed_small: :environment do
    puts "📋 通常のサンプルデータを生成中..."
    Rails.application.load_seed
  end

  desc "大規模データセット（100ユーザー + 大量タスク）を生成"
  task seed_large: :environment do
    puts "🚀 大規模データセットを生成中..."
    ENV['LARGE_DATASET'] = 'true'
    Rails.application.load_seed
    ENV.delete('LARGE_DATASET')
  end

  desc "データベースをリセットして大規模データセットを生成"
  task reset_with_large: :environment do
    puts "🔄 データベースリセット + 大規模データ生成を実行中..."

    # データベースをリセット
    Rake::Task['db:reset'].invoke

    # 大規模データを生成
    ENV['LARGE_DATASET'] = 'true'
    Rails.application.load_seed
    ENV.delete('LARGE_DATASET')

    puts "✅ リセット + 大規模データ生成完了！"
  end

  desc "現在のデータ統計を表示"
  task stats: :environment do
    puts "📊 現在のデータ統計:"
    puts "   - ユーザー数: #{User.count}名"
    puts "   - 管理者数: #{User.where(admin: true).count}名"
    puts "   - タスク数: #{Task.count}タスク"
    puts ""

    if User.count > 0
      puts "👥 ユーザー別タスク数:"
      User.joins(:tasks).group('users.name').count('tasks.id').sort_by { |name, count| -count }.each do |name, count|
        puts "   #{name}: #{count}タスク"
      end

      puts ""
      puts "📈 ステータス別タスク数:"
      Task.group(:status).count.each do |status, count|
        puts "   #{status}: #{count}タスク"
      end
    end
  end

  desc "データベースクリーンアップ（全データ削除）"
  task clean: :environment do
    puts "🧹 データベースクリーンアップ中..."

    Task.delete_all
    User.delete_all

    puts "✅ 全データが削除されました"
    puts "💡 新しいデータを生成するには以下を実行:"
    puts "   rails data:seed_small     # 通常データ"
    puts "   rails data:seed_large     # 大規模データ"
  end
end