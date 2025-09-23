require 'rails_helper'

RSpec.feature "Task Validation" do
  scenario "user sees improved validation errors when creating task with missing fields" do
    # Given: タスク作成ページにアクセス
    visit new_task_path

    # When: 必須項目を空で送信（優先度は選択する）
    select '中', from: 'task_priority'
    click_button "タスクを作成"

    # Then: 改善されたバリデーションエラーが表示される
    expect(page).to have_content("入力エラーがあります")
    expect(page).to have_content("Title can't be blank")  # 最初は英語メッセージで確認
    expect(page).to have_content("Description can't be blank")
  end

  scenario "user sees validation errors when creating task with too long fields" do
    # Given: タスク作成ページにアクセス
    visit new_task_path

    # When: 制限を超える長い文字を入力（find by idで確実にフィールドを指定）
    page.execute_script("document.getElementById('task_title').value = '#{'a' * 101}';")
    page.execute_script("document.getElementById('task_description').value = '#{'a' * 501}';")
    select '中', from: 'task_priority'
    click_button "タスクを作成"

    # Then: 文字数制限エラーが表示される
    expect(page).to have_content("入力エラーがあります")
    expect(page).to have_content("Title is too long")
    expect(page).to have_content("Description is too long")
  end
end