require 'rails_helper'

RSpec.feature "Task Index" do
  scenario "user can view their tasks on index page" do
    # Given: ログインユーザーとそのタスクが存在する
    user = create(:user)
    task1 = create(:task, user: user, title: "買い物に行く", description: "野菜を買う")
    task2 = create(:task, user: user, title: "レポート作成", description: "月次レポート")

    # When: ログインしてタスク一覧ページにアクセス
    # TODO: ログイン処理を実装後に追加
    visit tasks_path

    # Then: 自分のタスクが表示される
    expect(page).to have_content("買い物に行く")
    expect(page).to have_content("レポート作成")
  end
end