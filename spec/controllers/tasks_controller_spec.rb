require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "DELETE #destroy" do
    it "deletes the task and redirects to tasks index" do
      # Given: 既存のタスクが存在する
      user = create(:user)
      task = create(:task, user: user, title: "削除されるタスク")

      # When: destroyアクションを呼び出し
      expect(Task.count).to eq(1)  # 削除前の確認

      delete :destroy, params: { id: task.id }

      # Then: タスクが削除され、一覧ページにリダイレクト
      expect(response).to redirect_to(tasks_path)
      expect(Task.count).to eq(0)  # 削除後の確認
      expect(Task.find_by(id: task.id)).to be_nil  # タスクが存在しないことを確認
    end

    it "shows success message after deletion" do
      # Given: 既存のタスクが存在する
      user = create(:user)
      task = create(:task, user: user, title: "削除されるタスク")

      # When: destroyアクションを呼び出し
      delete :destroy, params: { id: task.id }

      # Then: 成功メッセージが設定される
      expect(flash[:notice]).to eq("タスクが削除されました")
    end

    it "handles non-existent task" do
      # When: 存在しないタスクIDでdestroyアクションを呼び出し
      expect {
        delete :destroy, params: { id: 99999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end