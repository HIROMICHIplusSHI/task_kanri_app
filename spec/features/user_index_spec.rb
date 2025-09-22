# coding: utf-8
require 'rails_helper'

RSpec.describe "UserIndex", type: :feature do
  let(:admin_user) { create(:user, name: "管理者", email: "admin@example.com", admin: true) }
  let(:regular_user) { create(:user, name: "一般ユーザー", email: "user@example.com") }

  describe "ユーザー一覧ページのアクセス制御" do
    context "管理者でログインしている場合" do
      before do
        visit login_path
        fill_in "session[email]", with: admin_user.email
        fill_in "session[password]", with: "password"
        click_button "Log In"
      end

      it "ユーザー一覧ページにアクセスできること" do
        visit users_path

        expect(page).to have_content("ユーザー一覧")
        expect(page).to have_content(admin_user.name)
        expect(page).to have_content(regular_user.name)
      end

      it "ヘッダーにユーザー一覧リンクが表示されること" do
        visit root_path

        expect(page).to have_link("ユーザー一覧", href: users_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before do
        visit login_path
        fill_in "session[email]", with: regular_user.email
        fill_in "session[password]", with: "password"
        click_button "Log In"
      end

      it "ユーザー一覧ページにアクセスできないこと" do
        visit users_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content("アクセス権限がありません")
      end

      it "ヘッダーにユーザー一覧リンクが表示されないこと" do
        visit root_path

        expect(page).not_to have_link("ユーザー一覧")
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        visit users_path

        expect(current_path).to eq(login_path)
        expect(page).to have_content("ログインしてください")
      end
    end
  end

  describe "ユーザー一覧ページの表示" do
    before do
      # 25名のユーザーを作成（ページネーションテスト用）
      25.times do |i|
        create(:user, name: "テストユーザー#{i + 1}", email: "test#{i + 1}@example.com")
      end

      visit login_path
      fill_in "Email", with: admin_user.email
      fill_in "Password", with: "password"
      click_button "Log In"
    end

    it "ページネーションが正しく動作すること" do
      visit users_path

      # 1ページ目に20名表示
      expect(page).to have_content("テストユーザー1")
      expect(page).to have_content("テストユーザー20")
      expect(page).not_to have_content("テストユーザー21")

      # ページネーションリンクが表示
      expect(page).to have_link("2")

      # 2ページ目に移動
      click_link "2"
      expect(page).to have_content("テストユーザー21")
      expect(page).to have_content("テストユーザー25")
    end

    it "ユーザー情報が正しく表示されること" do
      visit users_path

      expect(page).to have_content(admin_user.name)
      expect(page).to have_content(admin_user.email)
      expect(page).to have_content("管理者")

      expect(page).to have_content(regular_user.name)
      expect(page).to have_content(regular_user.email)
      expect(page).to have_content("一般ユーザー")
    end
  end
end