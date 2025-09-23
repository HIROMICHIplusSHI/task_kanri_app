# coding: utf-8
require 'rails_helper'

RSpec.describe "UserDetailEnhancement" do
  let(:user) { User.create!(name: "テストユーザー", email: "test@example.com",
                            password: "password", password_confirmation: "password") }
  let(:admin_user) { User.create!(name: "管理者", email: "admin@example.com",
                                  password: "password", password_confirmation: "password",
                                  admin: true) }

  before do
    # テスト用タスクを作成
    user.tasks.create!(title: "完了タスク1", description: "説明1", status: "完了", priority: "高")
    user.tasks.create!(title: "進行中タスク1", description: "説明2", status: "進行中", priority: "中")
    user.tasks.create!(title: "新規タスク1", description: "説明3", status: "新規", priority: "低")
    user.tasks.create!(title: "完了タスク2", description: "説明4", status: "完了", priority: "中")
    user.tasks.create!(title: "新規タスク2", description: "説明5", status: "新規", priority: "高")

    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log In"
  end

  describe "ユーザー詳細ページの機能拡張" do
    it "ユーザー情報が正しく表示されること" do
      visit user_path(user)

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content("一般ユーザー")
      expect(page).to have_content("プロフィール編集")
    end

    it "管理者バッジが正しく表示されること" do
      click_link "ログアウト"
      visit login_path
      fill_in "Email", with: admin_user.email
      fill_in "Password", with: "password"
      click_button "Log In"

      visit user_path(admin_user)
      expect(page).to have_content("管理者")
    end

    it "タスク統計情報が正しく表示されること" do
      visit user_path(user)

      expect(page).to have_content("タスク統計")
      expect(page).to have_content("5") # 総数
      expect(page).to have_content("2") # 完了数
      expect(page).to have_content("40.0%") # 完了率

      # ステータス別内訳
      expect(page).to have_content("完了")
      expect(page).to have_content("進行中")
      expect(page).to have_content("新規")

      # 優先度別内訳
      expect(page).to have_content("高")
      expect(page).to have_content("中")
      expect(page).to have_content("低")
    end

    it "タスク一覧が正しく表示されること" do
      visit user_path(user)

      expect(page).to have_content("#{user.name}のタスク一覧")
      expect(page).to have_content("完了タスク1")
      expect(page).to have_content("進行中タスク1")
      expect(page).to have_content("新規タスク1")
      expect(page).to have_content("完了タスク2")
      expect(page).to have_content("新規タスク2")

      # タスクの詳細情報も表示されること
      expect(page).to have_content("説明1")
      expect(page).to have_content("説明2")
    end

    it "タスクのリンクが正しく動作すること" do
      task = user.tasks.first
      visit user_path(user)

      click_link task.title
      expect(current_path).to eq(task_path(task))
    end

    it "タスクがない場合の表示が正しいこと" do
      empty_user = User.create!(name: "空ユーザー", email: "empty@example.com",
                                password: "password", password_confirmation: "password")

      visit user_path(empty_user)
      expect(page).to have_content("まだタスクが登録されていません")
      expect(page).to have_content("最初のタスクを作成")
    end

    it "ページネーションが正しく動作すること" do
      # 6個以上のタスクを作成（1ページ5件なので2ページ目が表示される）
      user.tasks.create!(title: "追加タスク1", description: "説明", status: "新規", priority: "中")

      visit user_path(user)

      # ページネーションリンクが表示されること
      expect(page).to have_link("2")

      # 2ページ目に移動
      click_link "2"
      expect(page).to have_content("追加タスク1")
    end
  end

  describe "権限制御" do
    let(:other_user) { User.create!(name: "他のユーザー", email: "other@example.com",
                                    password: "password", password_confirmation: "password") }

    it "本人のページは閲覧できること" do
      visit user_path(user)
      expect(page).to have_content(user.name)
      expect(page).to have_content("プロフィール編集")
    end

    it "管理者は他のユーザーのページを閲覧できること" do
      click_link "ログアウト"
      visit login_path
      fill_in "Email", with: admin_user.email
      fill_in "Password", with: "password"
      click_button "Log In"

      visit user_path(user)
      expect(page).to have_content(user.name)
      expect(page).to have_content("プロフィール編集") # 管理者は編集可能
    end
  end

  describe "レスポンシブデザイン" do
    it "モバイル表示でも正しくレイアウトされること" do
      # ウィンドウサイズを変更してモバイル表示をシミュレート
      page.driver.browser.manage.window.resize_to(480, 800)

      visit user_path(user)
      expect(page).to have_content(user.name)
      expect(page).to have_content("タスク統計")
    end
  end
end