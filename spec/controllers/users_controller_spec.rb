# coding: utf-8
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    context "ログインしていない場合" do
      it "新規登録ページが表示されること" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしている場合でも" do
      let(:user) { create(:user) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "新規登録ページが表示されること" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) {
      {
        name: "新規ユーザー",
        email: "newuser@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }

    context "ログインしていない場合" do
      it "ユーザーが作成され、ログインされること" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(User.last)
        expect(flash[:success]).to eq('新規作成に成功しました。')
      end

      it "無効なデータの場合は新規登録画面が再表示されること" do
        post :create, params: { user: { name: "", email: "invalid" } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #show" do
    let!(:target_user) { create(:user, name: "対象ユーザー", email: "target@example.com") }

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :show, params: { id: target_user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "管理者でログインしている場合" do
      let(:admin_user) { create(:user, admin: true) }

      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "任意のユーザーの詳細ページが表示されること" do
        get :show, params: { id: target_user.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "本人でログインしている場合" do
      before do
        allow(controller).to receive(:current_user).and_return(target_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "自分の詳細ページが表示されること" do
        get :show, params: { id: target_user.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "他人としてログインしている場合" do
      let(:other_user) { create(:user, name: "他のユーザー", email: "other@example.com") }

      before do
        allow(controller).to receive(:current_user).and_return(other_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ルートページにリダイレクトされること" do
        get :show, params: { id: target_user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("アクセス権限がありません")
      end
    end
  end

  describe "GET #edit" do
    let!(:target_user) { create(:user, name: "対象ユーザー", email: "target@example.com") }

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :edit, params: { id: target_user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context "本人でログインしている場合" do
      before do
        allow(controller).to receive(:current_user).and_return(target_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "編集ページが表示されること" do
        get :edit, params: { id: target_user.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "管理者でログインしている場合" do
      let(:admin_user) { create(:user, admin: true) }

      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ルートページにリダイレクトされること" do
        get :edit, params: { id: target_user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("アクセス権限がありません")
      end
    end

    context "他人としてログインしている場合" do
      let(:other_user) { create(:user, name: "他のユーザー", email: "other@example.com") }

      before do
        allow(controller).to receive(:current_user).and_return(other_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ルートページにリダイレクトされること" do
        get :edit, params: { id: target_user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("アクセス権限がありません")
      end
    end
  end

  describe "PATCH #update" do
    let!(:target_user) { create(:user, name: "対象ユーザー", email: "target@example.com") }
    let(:valid_attributes) { { name: "更新されたユーザー", email: "updated@example.com" } }

    context "本人でログインしている場合" do
      before do
        allow(controller).to receive(:current_user).and_return(target_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ユーザー情報が更新されること" do
        patch :update, params: { id: target_user.id, user: valid_attributes }
        expect(response).to redirect_to(target_user)
        expect(flash[:success]).to eq("プロフィールが更新されました")
      end
    end

    context "管理者でログインしている場合" do
      let(:admin_user) { create(:user, admin: true) }

      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it "ルートページにリダイレクトされること" do
        patch :update, params: { id: target_user.id, user: valid_attributes }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("アクセス権限がありません")
      end
    end
  end

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