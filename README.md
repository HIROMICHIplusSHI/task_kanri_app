# タスク管理アプリ

Test-Driven Development (TDD) で構築したタスク管理アプリケーションです。Ruby on Rails 7.1.5.2 + MySQL + Docker環境で開発しています。

## 📋 機能

### ✅ 実装済み機能
- **タスクCRUD操作** - 作成、表示、編集、削除
- **確認ダイアログ** - 削除時の確認機能
- **レスポンシブデザイン** - Bootstrap使用
- **包括的テスト** - RSpec + Factory Bot + Database Cleaner

### 🎯 今後の実装予定

#### Phase 5: バリデーション強化
- 必須項目バリデーション (title, description)
- 文字数制限バリデーション
- バリデーションエラー表示の改善

#### Phase 6: エラーハンドリング改善
- 404エラーページ対応
- 500エラーページ対応
- 存在しないタスクへのアクセス対応

#### Phase 7: 検索・フィルター機能
- タスク検索機能 (タイトル・説明)
- ステータス別フィルター
- 優先度別フィルター

#### Phase 8: ユーザー認証機能
- ログイン機能実装
- ユーザー登録機能実装
- タスクのユーザー所有権管理

#### Phase 9: 国際化 (i18n) 対応
- 日本語・英語対応
- エラーメッセージの多言語化

#### Phase 10: パフォーマンス・UI改善
- ページネーション実装
- CSS・デザイン改善
- レスポンシブ対応

## 🛠 技術スタック

- **言語**: Ruby 3.0.6
- **フレームワーク**: Ruby on Rails 7.1.5.2
- **データベース**: MySQL 5.7
- **コンテナ**: Docker / Docker Compose
- **テスト**: RSpec, Factory Bot, Database Cleaner, Capybara
- **フロントエンド**: Bootstrap 3.4.1, SCSS
- **開発手法**: Test-Driven Development (TDD)

## 🚀 セットアップ

### 必要な環境
- Docker
- Docker Compose
- Git

### 1. リポジトリのクローン
```bash
git clone git@github.com:HIROMICHIplusSHI/task_kanri_app.git
cd task_kanri_app
```

### 2. Docker環境構築
```bash
# イメージのビルド
docker-compose build

# 依存関係のインストール（root権限で実行）
docker-compose run --rm -u root web bundle install
```

### 3. データベースのセットアップ
```bash
# データベース作成とマイグレーション
docker-compose run --rm web bin/rails db:prepare

# シードデータの投入（オプション）
docker-compose run --rm web bin/rails db:seed

# ⚡ 推奨: 開発環境の自動セットアップ
docker-compose exec web bundle exec rake dev:setup
```

### 💡 ログイン後の使用
初回セットアップ後、以下の情報でログインできます：
- **Email**: test@example.com
- **Password**: password

### 4. アプリケーション起動
```bash
# フォアグラウンドで起動
docker-compose up

# バックグラウンドで起動
docker-compose up -d
```

アクセス: **http://localhost:3120**

## 🧪 テスト実行

```bash
# 全テスト実行
docker-compose exec web bundle exec rspec

# 特定のテスト実行
docker-compose exec web bundle exec rspec spec/features/
docker-compose exec web bundle exec rspec spec/controllers/
```

## 📊 開発情報

### TDD開発アプローチ
このプロジェクトは**Test-Driven Development (TDD)**で開発されています：

1. **Red**: 失敗するテストを書く
2. **Green**: テストをパスする最小限のコードを書く
3. **Refactor**: コードを改善し、テストが通ることを確認

### Git履歴について
**注意**: このリポジトリの履歴は2025年9月21日にクリーンアップされました。
- 元々は複数開発者による既存プロジェクトをベースにしていました
- 開発学習のため、履歴をリセットしてクリーンな状態から再スタートしました
- 現在の履歴は、TDD実装による成果のみを反映しています

### フェーズベース開発
機能を段階的に実装しており、各フェーズでTDDサイクルを実践：
- **Phase 1-4**: 基本CRUD操作（完了）
- **Phase 5-10**: 拡張機能（計画中）

## 🔧 よく使うコマンド

```bash
# Railsコンソール
docker-compose exec web bin/rails console

# ルーティング確認
docker-compose exec web bin/rails routes

# ログ確認
docker-compose logs -f web

# データベースリセット
docker-compose exec web bin/rails db:reset

# 新しいマイグレーション作成
docker-compose exec web bin/rails generate migration MigrationName

# 停止と片付け
docker-compose down
```

## ⚠️ よくある問題と解決法

### ログインできない場合
**症状**: 「認証に失敗しました」と表示される
**原因**: Dockerコンテナ再起動によりユーザーデータが初期化された
**解決法**:
```bash
# ユーザーデータの確認
docker-compose exec web bundle exec rails console -e development
> User.count

# ユーザーが0の場合、シード実行
docker-compose exec web bundle exec rake db:seed

# または開発環境セットアップ
docker-compose exec web bundle exec rake dev:setup
```

### 開発中のデータ消失について
このアプリケーションでは、以下の場合にユーザーデータが初期化されます：
- `docker-compose down/up` の実行
- Dockerコンテナの再起動
- システムの再起動

**対策**: 定期的に `rake dev:setup` を実行してユーザーデータを確認してください。

## 🤖 開発支援

このプロジェクトは [Claude Code](https://claude.ai/code) を使用してTest-Driven Development手法で開発されました。

## 📝 ライセンス

このプロジェクトは学習目的で作成されています。