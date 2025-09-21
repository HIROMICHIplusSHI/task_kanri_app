# TaskApp - Claude開発メモ

## プロジェクト概要
- **名前**: TaskApp (タスク管理アプリ)
- **フレームワーク**: Ruby on Rails 7.1.5.2
- **データベース**: MySQL 5.7 (Docker)
- **環境**: Docker Compose
- **言語**: 日本語専用（英語国際化は廃止済み）

## 開発環境
```bash
# 起動
docker-compose up -d

# アクセス
http://localhost:3000

# DB接続
docker-compose exec db mysql -u root -ppassword myapp_development

# Rails console
docker-compose exec web bundle exec rails console

# テスト実行
docker-compose exec web bundle exec rspec

# アセット再コンパイル（必要時）
docker-compose exec web bundle exec rails assets:precompile
```

## 認証情報
### ログインユーザー
- **sample@email.com** / password (Sample User)
- **seisaku@email.com** / password (制作ユーザー)

### シードデータ再作成
```bash
docker-compose exec web bundle exec rails db:seed
```

## データベース管理
### バックアップ
```bash
# バックアップ作成
docker-compose exec web bundle exec rake db:backup

# 復元
docker-compose exec web bundle exec rake db:restore[db/backups/backup_file.sql]
```

## 開発履歴（Phase順）

### ✅ Phase 1-4: 基盤構築
- 初期設定、TDD実装、基本機能

### ✅ Phase 5: バリデーション強化
- フォームバリデーション改善

### ✅ Phase 6: エラーハンドリング
- 404/500エラー対応

### ✅ Phase 7-8: 認証システム
- ユーザー登録・ログイン機能

### ✅ Phase 9: 国際化対応（後に廃止）
- 多言語対応実装 → 日本語専用に変更

### ✅ Phase 10: UI/UX改善
- レスポンシブデザイン
- ページネーション
- モダンUIデザイン
- ステータス・優先度バッジ

### ✅ 追加改善
- **国際化廃止**: 日本語専用アプリに簡素化
- **データベース永続化対策**: バックアップシステム実装

## 現在の機能
1. **ユーザー認証**
   - 新規登録・ログイン・ログアウト
   - セッション管理

2. **タスク管理**
   - CRUD操作（作成・表示・編集・削除）
   - ステータス管理（新規・進行中・完了）
   - 優先度設定（高・中・低）
   - 期限設定

3. **UI/UX**
   - レスポンシブデザイン（モバイル対応）
   - ページネーション（5件/ページ）
   - ステータス・優先度バッジ
   - カードスタイルフォーム
   - ホバーエフェクト

4. **データベース**
   - MySQL永続化
   - 自動バックアップシステム
   - シードデータ管理

## 技術スタック
- **Backend**: Ruby on Rails 7.1.5.2
- **Database**: MySQL 5.7
- **Frontend**: Bootstrap 3.4.1 + Custom CSS
- **Testing**: RSpec + Capybara
- **Infrastructure**: Docker + Docker Compose
- **Pagination**: will_paginate gem

## ディレクトリ構造
```
task_kanri_app/
├── app/
│   ├── controllers/     # コントローラー
│   ├── models/          # モデル
│   ├── views/           # ビュー
│   └── assets/          # CSS/JS
├── spec/                # テストファイル
├── db/
│   ├── migrate/         # マイグレーション
│   ├── seeds.rb         # シードデータ
│   └── backups/         # バックアップファイル
├── lib/tasks/           # Rakeタスク
└── config/
    ├── locales/         # 日本語ロケール
    └── database.yml     # DB設定
```

## よくある問題と解決策

### ログインできない問題
**原因**: ユーザーデータが存在しない
**解決**:
```bash
docker-compose exec web bundle exec rails db:seed
```

### CSS変更が反映されない
**解決**:
```bash
docker-compose exec web bundle exec rails assets:precompile
docker-compose restart web
```

### テスト失敗（403エラー）
**原因**: Host Authorization
**対処**: 開発環境では一般的な問題、本番では設定要

### データ消失問題
**対策**: 定期的にバックアップ実行
```bash
docker-compose exec web bundle exec rake db:backup
```

## Git管理
- **メインブランチ**: main
- **リモート**: git@github.com:HIROMICHIplusSHI/task_kanri_app.git
- **ブランチ戦略**: feature/機能名 → main

## 重要な注意事項
1. **テスト実行時**: developmentデータベースに影響する可能性あり
2. **Docker停止時**: データベースは永続化されているが、念のためバックアップ推奨
3. **アセット変更時**: プリコンパイル必須
4. **本番運用時**: Host Authorization設定必要

## 次回セッション時のチェックリスト
1. [ ] Docker起動確認
2. [ ] ログイン動作確認（seisaku@email.com）
3. [ ] 必要に応じてバックアップ作成
4. [ ] git statusで作業ブランチ確認

---
**最終更新**: 2025-09-21
**開発時間**: ~18時間
**状態**: 本格運用可能