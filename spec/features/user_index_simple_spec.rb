# coding: utf-8
require 'rails_helper'

RSpec.describe "UserIndex Simple" do
  let(:admin_user) { create(:user, admin: true) }
  let(:regular_user) { create(:user) }

  describe "認証なしでのアクセス制御" do
    it "ログインしていない場合はログインページにリダイレクトされること" do
      visit users_path

      expect(current_path).to eq(login_path)
    end
  end

  describe "管理者ログイン後のアクセス" do
    it "管理者でログインするとユーザー一覧ページにアクセスできること" do
      login_as(admin_user)

      visit users_path
      expect(page).to have_content("ユーザー一覧")
    end
  end

  describe "一般ユーザーのアクセス制御" do
    it "一般ユーザーでログインするとアクセス拒否されること" do
      login_as(regular_user)

      visit users_path
      expect(current_path).to eq(root_path)
      expect(page).to have_content("アクセス権限がありません")
    end
  end
end