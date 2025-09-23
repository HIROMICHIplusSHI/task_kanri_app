require 'rails_helper'

RSpec.describe "Task Ownership" do
  let(:user1) { create(:user, email: "user1@example.com") }
  let(:user2) { create(:user, email: "user2@example.com") }
  let(:user1_task) { create(:task, user: user1) }
  let(:user2_task) { create(:task, user: user2) }

  describe "task index" do
    it "shows only current user's tasks" do
      # user1とuser2のタスクを作成
      user1_task
      user2_task

      # user1でログイン
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)

      get "/tasks"

      expect(response.body).to include(user1_task.title)
      expect(response.body).not_to include(user2_task.title)
    end
  end

  describe "task show" do
    it "allows access to own task" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)

      get "/tasks/#{user1_task.id}"

      expect(response).to have_http_status(200)
      expect(response.body).to include(user1_task.title)
    end

    it "denies access to other user's task" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)

      get "/tasks/#{user2_task.id}"

      expect(response).to have_http_status(403)
      expect(response.body).to include("アクセス権限がありません")
    end
  end

  describe "task edit" do
    it "allows editing own task" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)

      get "/tasks/#{user1_task.id}/edit"

      expect(response).to have_http_status(200)
    end

    it "denies editing other user's task" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)

      get "/tasks/#{user2_task.id}/edit"

      expect(response).to have_http_status(403)
    end
  end
end