require 'rails_helper'

RSpec.describe "ページネーション機能", type: :request do
  let(:user) { create(:user) }

  before do
    post login_path, params: { session: { email: user.email, password: 'password' } }
  end

  describe "GET /tasks" do
    it "5件以下のタスクの場合、全件表示される" do
      create_list(:task, 3, user: user)
      get tasks_path

      expect(response).to have_http_status(:success)
      expect(response.body).not_to include('pagination')
    end

    it "5件を超えるタスクの場合、ページネーションが表示される" do
      create_list(:task, 8, user: user)
      get tasks_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('pagination')
    end

    it "pageパラメータで2ページ目が取得できる" do
      create_list(:task, 8, user: user)
      get tasks_path, params: { page: 2 }

      expect(response).to have_http_status(:success)
    end

    it "他のユーザーのタスクは表示されない" do
      other_user = create(:user, email: 'other@example.com')
      my_task = create(:task, user: user, title: "My Task")
      other_task = create(:task, user: other_user, title: "Other Task")

      get tasks_path

      expect(response.body).to include("My Task")
      expect(response.body).not_to include("Other Task")
    end
  end
end