# coding: utf-8
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      let(:user) { create(:user) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ルートページにリダイレクトされること" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("アクセス権限がありません")
      end
    end

    context "管理者でログインしている場合" do
      let(:admin_user) { create(:user, admin: true) }

      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ユーザー一覧ページが表示されること" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:target_user) { create(:user, name: "削除対象ユーザー", email: "target@example.com") }

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        delete :destroy, params: { id: target_user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      let(:user) { create(:user) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ルートページにリダイレクトされること" do
        delete :destroy, params: { id: target_user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("アクセス権限がありません")
      end
    end

    context "管理者でログインしている場合" do
      let(:admin_user) { create(:user, admin: true) }

      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ユーザーが削除されること" do
        initial_count = User.count
        delete :destroy, params: { id: target_user.id }
        final_count = User.count

        expect(final_count).to eq(initial_count - 1)
        expect(response).to redirect_to(users_path)
        expect(flash[:success]).to include("削除されました")
      end

      it "自分自身は削除できないこと" do
        expect {
          delete :destroy, params: { id: admin_user.id }
        }.not_to change(User, :count)
        expect(response).to redirect_to(users_path)
        expect(flash[:error]).to eq("自分自身は削除できません")
      end
    end
  end
end