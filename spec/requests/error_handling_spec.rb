require 'rails_helper'

RSpec.describe "Error Handling" do
  let(:user) { create(:user) }

  before do
    # ログインユーザーをセットアップ
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
  end
  describe "404 errors" do
    it "renders 404 page for non-existent task" do
      get "/tasks/99999"
      expect(response).to have_http_status(404)
      expect(response.body).to include("ページが見つかりません")
    end

    it "renders 404 page for non-existent route" do
      get "/non_existent_page"
      expect(response).to have_http_status(404)
      expect(response.body).to include("ページが見つかりません")
    end
  end

  describe "500 errors" do
    it "handles server errors gracefully" do
      # 意図的にエラーを発生させるテスト
      allow_any_instance_of(TasksController).to receive(:show).and_raise(StandardError)

      get "/tasks/1"
      expect(response).to have_http_status(500)
      expect(response.body).to include("サーバーエラーが発生しました")
    end
  end
end