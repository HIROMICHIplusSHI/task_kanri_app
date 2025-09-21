require 'rails_helper'

RSpec.feature "Task Edit", type: :feature do
  scenario "user can edit an existing task successfully" do
    # Given: 既存のタスクが存在する
    user = create(:user)
    task = create(:task, user: user, title: "元のタイトル", description: "元の説明")

    # When: タスクの編集ページにアクセスして更新
    visit edit_task_path(task)
    fill_in "task[title]", with: "更新されたタイトル"
    fill_in "task[description]", with: "更新された説明"
    select "低", from: "task[priority]"
    click_button "タスクを更新"

    # Then: タスクが更新され、詳細ページに移動
    expect(page).to have_content("更新されたタイトル")
    expect(page).to have_content("更新された説明")
    expect(page).to have_content("低")
    expect(page).to have_content("タスクが更新されました")
  end

  scenario "user sees validation errors when editing with invalid data" do
    # Given: 既存のタスクが存在する
    user = create(:user)
    task = create(:task, user: user, title: "元のタイトル")

    # When: 空のタイトルで更新を試行
    visit edit_task_path(task)
    fill_in "task[title]", with: ""
    click_button "タスクを更新"

    # Then: バリデーションエラーが表示される
    expect(page).to have_content("Title can't be blank")
    expect(current_path).to eq(task_path(task))  # edit後はPUTでtask_pathにpost
  end

  scenario "user can navigate to edit page from task detail page" do
    # Given: 既存のタスクが存在する
    user = create(:user)
    task = create(:task, user: user)

    # When: 詳細ページから編集ページにアクセス
    visit task_path(task)
    click_link "編集"

    # Then: 編集ページに移動し、現在の値が表示される
    expect(current_path).to eq(edit_task_path(task))
    expect(page).to have_field("task[title]", with: task.title)
    expect(page).to have_field("task[description]", with: task.description)
  end
end