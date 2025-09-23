require 'rails_helper'

RSpec.feature "ページネーション機能" do
  let(:user) { create(:user) }

  before do
    login_user(user)
  end

  scenario "タスクが5件以下の場合、ページネーションが表示されない" do
    create_list(:task, 3, user: user)
    visit tasks_path

    expect(page).not_to have_css('.pagination')
    expect(page).to have_css('.task-item', count: 3)
  end

  scenario "タスクが5件を超える場合、ページネーションが表示される" do
    create_list(:task, 8, user: user)
    visit tasks_path

    expect(page).to have_css('.pagination')
    expect(page).to have_css('.task-item', count: 5)
    expect(page).to have_link('Next')
    expect(page).to have_link('2')
  end

  scenario "次のページに移動できる" do
    tasks = create_list(:task, 8, user: user)
    visit tasks_path

    # 1ページ目に最新の5件が表示される
    expect(page).to have_content(tasks[7].title)
    expect(page).to have_content(tasks[6].title)
    expect(page).to have_content(tasks[5].title)
    expect(page).to have_content(tasks[4].title)
    expect(page).to have_content(tasks[3].title)
    expect(page).not_to have_content(tasks[2].title)

    # 次のページをクリック
    click_link 'Next'

    # 2ページ目に残りの3件が表示される
    expect(page).to have_content(tasks[2].title)
    expect(page).to have_content(tasks[1].title)
    expect(page).to have_content(tasks[0].title)
    expect(page).not_to have_content(tasks[7].title)

    expect(page).to have_link('Previous')
  end

  scenario "ページ番号で直接移動できる" do
    create_list(:task, 12, user: user)
    visit tasks_path

    # ページ2に直接移動
    click_link '2'
    expect(current_path).to eq(tasks_path)
    expect(page).to have_css('.task-item', count: 5)

    # ページ3に直接移動
    click_link '3'
    expect(page).to have_css('.task-item', count: 2)
  end

  scenario "他のユーザーのタスクはページネーションに含まれない" do
    other_user = create(:user, email: 'other@example.com')
    create_list(:task, 5, user: user)
    create_list(:task, 10, user: other_user)

    visit tasks_path

    # 自分のタスクのみ表示され、ページネーションは不要
    expect(page).to have_css('.task-item', count: 5)
    expect(page).not_to have_css('.pagination')
  end
end