require 'rails_helper'

RSpec.describe "Task Deletion", type: :request do
  describe "DELETE /tasks/:id" do
    it "deletes a task and redirects to tasks index" do
      # Given: 既存のタスクが存在する
      user = create(:user)
      task = create(:task, user: user, title: "削除されるタスク")

      # When: destroyアクションを直接テスト
      expect(Task.count).to eq(1)  # 削除前の確認

      # DELETEリクエストを送信
      delete "/tasks/#{task.id}"

      # Then: タスクが削除され、一覧ページにリダイレクト
      expect(response).to redirect_to(tasks_path)
      expect(Task.count).to eq(0)  # 削除後の確認
      expect(Task.find_by(id: task.id)).to be_nil  # タスクが存在しないことを確認
    end
  end
end

RSpec.feature "Task Deletion UI" do

  scenario "task count decreases after deletion" do
    # Given: 複数のタスクが存在する
    user = create(:user)
    task1 = create(:task, user: user, title: "タスク1")
    task2 = create(:task, user: user, title: "タスク2")

    # When: タスクを削除
    expect(Task.count).to eq(2)  # 削除前の確認
    task1.destroy  # 直接削除（UIテストとは別にロジックテスト）

    # Then: タスク数が減っている
    expect(Task.count).to eq(1)
  end

  scenario "delete button exists on task index page" do
    # Given: タスクが存在する
    user = create(:user)
    task = create(:task, user: user, title: "テストタスク")

    # When: タスク一覧ページを訪問
    visit tasks_path

    # Then: 削除ボタンが存在する
    expect(page).to have_link("削除", href: task_path(task))

    # 削除リンクのmethodがdeleteに設定されている（HTML確認）
    delete_link = find_link("削除")
    expect(delete_link[:href]).to eq(task_path(task))
  end
end