require 'rails_helper'

RSpec.feature "Task Creation", type: :feature do
  scenario "user can create a new task successfully" do
    # Given: ログインユーザーが存在する
    user = create(:user)
    # TODO: ログイン処理を実装後に追加

    # When: 新規タスク作成ページにアクセスして入力
    visit new_task_path
    fill_in "task[title]", with: "新しいタスク"
    fill_in "task[description]", with: "これは新しいタスクの説明です"
    select "高", from: "task[priority]"
    fill_in "task[due_date]", with: "2024-12-31"
    click_button "タスクを作成"

    # Then: タスクが作成され、詳細ページまたは一覧ページに移動
    expect(page).to have_content("新しいタスク")
    expect(page).to have_content("これは新しいタスクの説明です")
    expect(page).to have_content("タスクが作成されました")
  end

  scenario "user sees validation errors for empty title" do
    # Given: ログインユーザーが存在する
    user = create(:user)

    # When: 空のタイトルでタスク作成を試行
    visit new_task_path
    fill_in "task[title]", with: ""
    click_button "タスクを作成"

    # Then: バリデーションエラーが表示される
    expect(page).to have_content("Title can't be blank")
  end
end