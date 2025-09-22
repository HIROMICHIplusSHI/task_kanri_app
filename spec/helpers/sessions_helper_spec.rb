# coding: utf-8
require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:admin_user) { User.create!(name: "管理者", email: "admin@example.com",
                                  password: "password", password_confirmation: "password", admin: true) }
  let(:regular_user) { User.create!(name: "一般ユーザー", email: "user@example.com",
                                    password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(name: "他のユーザー", email: "other@example.com",
                                  password: "password", password_confirmation: "password") }

  describe "#admin_only" do
    context "管理者でログインしている場合" do
      before { allow(helper).to receive(:current_user).and_return(admin_user) }

      it "trueを返すこと" do
        expect(helper.admin_only).to be true
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { allow(helper).to receive(:current_user).and_return(regular_user) }

      it "falseを返すこと" do
        expect(helper.admin_only).to be false
      end
    end

    context "ログインしていない場合" do
      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "falseを返すこと" do
        expect(helper.admin_only).to be false
      end
    end
  end

  describe "#owner_or_admin?" do
    context "管理者でログインしている場合" do
      before { allow(helper).to receive(:current_user).and_return(admin_user) }

      it "任意のユーザーに対してtrueを返すこと" do
        expect(helper.owner_or_admin?(regular_user)).to be true
        expect(helper.owner_or_admin?(other_user)).to be true
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { allow(helper).to receive(:current_user).and_return(regular_user) }

      it "本人に対してはtrueを返すこと" do
        expect(helper.owner_or_admin?(regular_user)).to be true
      end

      it "他人に対してはfalseを返すこと" do
        expect(helper.owner_or_admin?(other_user)).to be false
      end
    end

    context "ログインしていない場合" do
      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "falseを返すこと" do
        expect(helper.owner_or_admin?(regular_user)).to be false
      end
    end
  end
end