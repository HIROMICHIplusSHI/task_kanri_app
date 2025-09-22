# coding: utf-8
require 'rails_helper'

RSpec.describe "UserEdit", type: :feature do
  let(:user) { User.create!(name: "テストユーザー", email: "test@example.com",
                            password: "password", password_confirmation: "password") }
  let(:admin_user) { User.create!(name: "管理者", email: "admin@example.com",
                                  password: "password", password_confirmation: "password",
                                  admin: true) }
  let(:other_user) { User.create!(name: "他のユーザー", email: "other@example.com",
                                  password: "password", password_confirmation: "password") }

  before do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log In"
  end

  describe "ユーザー編集ページ" do
    it "正しい内容が表示されること" do
      visit edit_user_path(user)

      expect(page).to have_content("プロフィール編集")
      expect(page).to have_field("user_name", with: user.name)
      expect(page).to have_field("user_email", with: user.email)
      expect(page).to have_field("user_password")
      expect(page).to have_field("user_password_confirmation")
      expect(page).to have_button("更新")
      expect(page).to have_link("戻る")
    end

    it "プロフィール情報を更新できること" do
      visit edit_user_path(user)

      fill_in "user_name", with: "更新されたユーザー"
      fill_in "user_email", with: "updated@example.com"
      click_button "更新"

      expect(page).to have_content("プロフィールが更新されました")
      expect(page).to have_content("更新されたユーザー")

      user.reload
      expect(user.name).to eq("更新されたユーザー")
      expect(user.email).to eq("updated@example.com")
    end

    it "パスワードを変更できること" do
      visit edit_user_path(user)

      fill_in "user_password", with: "newpassword"
      fill_in "user_password_confirmation", with: "newpassword"
      click_button "更新"

      expect(page).to have_content("プロフィールが更新されました")

      # 新しいパスワードでログインできることを確認
      click_link "ログアウト"
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "newpassword"
      click_button "Log In"

      expect(page).to have_content("ログインしました")
    end

    it "パスワードを空白にした場合は変更されないこと" do
      original_password_digest = user.password_digest

      visit edit_user_path(user)

      fill_in "user_name", with: "名前のみ更新"
      # パスワードフィールドは空白のまま
      click_button "更新"

      expect(page).to have_content("プロフィールが更新されました")

      user.reload
      expect(user.name).to eq("名前のみ更新")
      expect(user.password_digest).to eq(original_password_digest)
    end

    it "無効な情報では更新できないこと" do
      visit edit_user_path(user)

      fill_in "user_name", with: ""
      fill_in "user_email", with: "invalid-email"
      click_button "更新"

      expect(page).to have_content("名前を入力してください")
      expect(page).to have_content("メールアドレスは不正な値です")
    end

    it "パスワード確認が一致しない場合は更新できないこと" do
      visit edit_user_path(user)

      fill_in "user_password", with: "newpassword"
      fill_in "user_password_confirmation", with: "different"
      click_button "更新"

      expect(page).to have_content("パスワード（確認用）とパスワードの入力が一致しません")
    end
  end

  describe "認可制御" do
    it "他のユーザーの編集ページにはアクセスできないこと" do
      visit edit_user_path(other_user)
      expect(current_path).to eq(root_path)
    end

    it "管理者は他のユーザーを編集できること" do
      # 管理者でログイン
      click_link "ログアウト"
      visit login_path
      fill_in "Email", with: admin_user.email
      fill_in "Password", with: "password"
      click_button "Log In"

      visit edit_user_path(user)
      expect(page).to have_content("プロフィール編集")

      fill_in "user_name", with: "管理者が更新"
      click_button "更新"

      expect(page).to have_content("プロフィールが更新されました")
      user.reload
      expect(user.name).to eq("管理者が更新")
    end
  end

  describe "ユーザー詳細ページ" do
    it "編集リンクが表示されること（本人の場合）" do
      visit user_path(user)
      expect(page).to have_link("プロフィール編集")
    end

    it "管理者バッジが表示されること" do
      visit user_path(admin_user)
      expect(page).to have_content("管理者")
    end

    it "他のユーザーには編集リンクが表示されないこと" do
      visit user_path(other_user)
      expect(page).not_to have_link("プロフィール編集")
    end
  end
end