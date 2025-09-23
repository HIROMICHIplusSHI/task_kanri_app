# TaskApp - タスク管理アプリケーション

Test-Driven Development (TDD) で構築した本格的なタスク管理アプリケーションです。
Ruby on Rails 7.1.5.2 + MySQL + Docker 環境で開発し、認証機能、ユーザー管理、UI/UX 改善を実装済みです。

## ✨ 主要機能

### 🔐 認証・ユーザー管理

- **ユーザー登録・ログイン** - セッション管理、Remember Me 機能
- **管理者権限システム** - 一般ユーザーと管理者の権限分離
- **ユーザー一覧・詳細** - 管理者向けユーザー管理機能
- **プロフィール管理** - ユーザー情報の編集・更新

### 📝 タスク管理

- **タスク CRUD 操作** - 作成、表示、編集、削除
- **ステータス管理** - 新規・進行中・完了の 3 段階
- **優先度設定** - 高・中・低の優先度管理
- **期限設定** - 日付指定によるタスク管理
- **URL 自動リンク化** - タスク説明内の URL を自動でリンク変換

### 🛡️ セキュリティ機能

- **認可システム** - ユーザーリソースへのアクセス制御
- **管理者保護** - 管理者ユーザーの削除防止
- **所有者チェック** - タスクの所有者のみが編集・削除可能
- **適切なリダイレクト** - ログイン済みユーザーの体験向上

### 🎨 UI/UX

- **レスポンシブデザイン** - モバイル・デスクトップ対応
- **モダン UI** - Bootstrap + カスタム CSS
- **ページネーション** - 効率的なデータ表示（ユーザー：20 件/ページ、タスク：5 件/ページ）
- **フラッシュメッセージ** - 統一されたメッセージ表示
- **削除確認ダイアログ** - 安全な削除操作
- **ステータス・優先度バッジ** - 視覚的な情報表示

### 💾 データ管理

- **大量サンプルデータ生成** - 100 ユーザー + 大量タスクデータ
- **バックアップシステム** - データベースの自動バックアップ・復元
- **シードデータ管理** - 開発環境の簡単リセット

## 🛠 技術スタック

- **言語**: Ruby 3.0.6
- **フレームワーク**: Ruby on Rails 7.1.5.2
- **データベース**: MySQL 5.7 (永続化対応)
- **コンテナ**: Docker / Docker Compose
- **テスト**: RSpec, Factory Bot, Capybara
- **コード品質**: RuboCop, rubocop-rails, rubocop-rspec
- **フロントエンド**: Bootstrap 3.4.1, SCSS, Rails UJS
- **ページネーション**: will_paginate gem
- **開発手法**: Test-Driven Development (TDD) + Static Code Analysis

## 🚀 クイックスタート

### 1. 環境構築

```bash
git clone git@github.com:HIROMICHIplusSHI/task_kanri_app.git
cd task_kanri_app
docker-compose up -d
```

### 2. データベースセットアップ

```bash
# 基本セットアップ（2ユーザー + 少量タスク）
docker-compose exec web bundle exec rails db:seed

# 大規模データセット（100ユーザー + 大量タスク）
docker-compose exec web bundle exec rake data:seed_large
```

### 3. アクセス

- **URL**: http://localhost:3000
- **テストユーザー**:
  - sample@email.com / password (一般ユーザー)
  - seisaku@email.com / password (管理者)

## 🧪 テスト実行

```bash
# 全テスト実行
docker-compose exec web bundle exec rspec

# 特定のテストスイート
docker-compose exec web bundle exec rspec spec/controllers/
docker-compose exec web bundle exec rspec spec/features/

# コード品質チェック
docker-compose exec web bundle exec rubocop

# コード品質自動修正
docker-compose exec web bundle exec rubocop --autocorrect
```

## 🔧 便利なコマンド

### データ管理

```bash
# バックアップ作成
docker-compose exec web bundle exec rake data:backup

# データ復元
docker-compose exec web bundle exec rake data:restore

# データベースリセット
docker-compose exec web bundle exec rake data:reset

# 大規模テストデータ生成
docker-compose exec web bundle exec rake data:seed_large

# データ統計表示
docker-compose exec web bundle exec rake data:stats
```

### 開発支援

```bash
# Railsコンソール
docker-compose exec web bundle exec rails console

# ルーティング確認
docker-compose exec web bundle exec rails routes

# ログ確認
docker-compose logs -f web

# アセット再コンパイル
docker-compose exec web bundle exec rails assets:precompile
```

## 📊 開発履歴

### ✅ Phase 1-4: 基盤構築 (完了)

- 基本 CRUD 操作、TDD 実装、テスト環境構築

### ✅ Phase 5-6: 品質向上 (完了)

- バリデーション強化、エラーハンドリング、404/500 対応

### ✅ Phase 7-8: 認証システム (完了)

- ユーザー登録・ログイン機能、セッション管理

### ✅ Phase 9: 国際化対応 → 日本語専用化 (完了)

- 多言語対応実装後、アプリの性質を考慮して日本語専用に変更

### ✅ Phase 10: UI/UX 改善 (完了)

- レスポンシブデザイン、ページネーション、モダン UI

### ✅ ユーザー管理システム (完了)

- ユーザー一覧・詳細・削除機能、権限管理、認可システム

### ✅ 最終品質向上 (完了)

- フラッシュメッセージ統一、URL 自動リンク化、セキュリティ強化

### ✅ コード品質保証システム (完了)

- RuboCop 静的解析導入、1,100+ 自動修正適用、コードスタイル統一

## 🏗️ アーキテクチャ特徴

### セキュリティ

- **3 層認可システム**: admin_only, owner_only, owner_or_admin
- **管理者保護**: 管理者間の削除防止
- **適切なリダイレクト**: ログイン状態に応じた画面遷移

### UI/UX 設計

- **レスポンシブファースト**: モバイル・デスクトップ両対応
- **情報設計**: 重要情報の視覚的強調（バッジ、カラーコーディング）
- **ユーザビリティ**: 確認ダイアログ、分かりやすいメッセージ

### データ設計

- **効率的ページネーション**: 大量データ対応
- **永続化対応**: Docker 環境でのデータ保持
- **バックアップ戦略**: 定期的なデータ保護

## ⚠️ トラブルシューティング

### ログインできない場合

```bash
# ユーザーデータの確認と復旧
docker-compose exec web bundle exec rails db:seed
```

### データが消失した場合

```bash
# バックアップから復元
docker-compose exec web bundle exec rake data:restore

# 新規データ生成
docker-compose exec web bundle exec rake data:seed_large
```

### CSS 変更が反映されない場合

```bash
# アセット再コンパイル
docker-compose exec web bundle exec rails assets:precompile
docker-compose restart web
```

## 📈 プロジェクト統計

- **開発期間**: 約 22 時間
- **コミット数**: 17+ commits
- **テストカバレッジ**: 主要機能 100%
- **実装機能数**: 25+ features
- **コード品質**: TDD + RuboCop による二重品質保証
- **RuboCop**: 70ファイル、0件違反（1,100+修正適用済み）

## 🤖 開発支援

このプロジェクトは [Claude Code](https://claude.ai/code) を活用して Test-Driven Development + Static Code Analysis 手法で開発されました。

---

**最終更新**: 2025-09-23
**バージョン**: v1.0.0 (完成版)
