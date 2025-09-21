require 'rails_helper'

RSpec.feature "UIデザイン改善", type: :feature do
  let(:user) { create(:user) }

  before do
    login_user(user)
  end

  scenario "タスク一覧でステータスバッジが表示される" do
    # 異なるステータスのタスクを作成
    task_new = create(:task, user: user, title: "新規タスク", status: "新規")
    task_progress = create(:task, user: user, title: "進行中タスク", status: "進行中")
    task_completed = create(:task, user: user, title: "完了タスク", status: "完了")

    visit tasks_path

    # ステータスバッジが表示されることを確認
    expect(page).to have_css('.status-badge.status-new')
    expect(page).to have_css('.status-badge.status-progress')
    expect(page).to have_css('.status-badge.status-completed')

    # バッジのテキストが正しいことを確認
    within('.status-badge.status-new') { expect(page).to have_content('新規') }
    within('.status-badge.status-progress') { expect(page).to have_content('進行中') }
    within('.status-badge.status-completed') { expect(page).to have_content('完了') }
  end

  scenario "タスク一覧で優先度バッジが表示される" do
    # 異なる優先度のタスクを作成
    task_high = create(:task, user: user, title: "高優先度タスク", priority: "高")
    task_medium = create(:task, user: user, title: "中優先度タスク", priority: "中")
    task_low = create(:task, user: user, title: "低優先度タスク", priority: "低")

    visit tasks_path

    # 優先度バッジが表示されることを確認
    expect(page).to have_css('.priority-badge.priority-high')
    expect(page).to have_css('.priority-badge.priority-medium')
    expect(page).to have_css('.priority-badge.priority-low')

    # バッジのテキストが正しいことを確認
    within('.priority-badge.priority-high') { expect(page).to have_content('高') }
    within('.priority-badge.priority-medium') { expect(page).to have_content('中') }
    within('.priority-badge.priority-low') { expect(page).to have_content('低') }
  end

  scenario "新規作成フォームでカードスタイルが適用される" do
    visit new_task_path

    # カードコンテナが表示されることを確認
    expect(page).to have_css('.card-container')

    # フォーム要素が含まれていることを確認
    within('.card-container') do
      expect(page).to have_field('task_title')
      expect(page).to have_field('task_description')
      expect(page).to have_button('タスクを作成')
    end
  end

  scenario "編集フォームでカードスタイルが適用される" do
    task = create(:task, user: user)
    visit edit_task_path(task)

    # カードコンテナが表示されることを確認
    expect(page).to have_css('.card-container')

    # フォーム要素が含まれていることを確認
    within('.card-container') do
      expect(page).to have_field('task_title')
      expect(page).to have_field('task_description')
      expect(page).to have_button('タスクを更新')
    end
  end

  scenario "タスクアイテムにホバーエフェクトが適用される" do
    task = create(:task, user: user)
    visit tasks_path

    # タスクアイテムが表示されることを確認
    expect(page).to have_css('.task-item')

    # CSSクラスが適用されていることを確認（JavaScript無効環境では実際のホバーエフェクトは確認できない）
    task_item = page.find('.task-item')
    expect(task_item[:style]).to include('transition')
  end

  scenario "レスポンシブボタンが適用される" do
    visit new_task_path

    # レスポンシブボタンクラスが適用されることを確認
    expect(page).to have_css('.btn-responsive')

    # 作成ボタンとキャンセルボタンの両方に適用されることを確認
    expect(page).to have_css('input[type="submit"].btn-responsive')
    expect(page).to have_css('a.btn-responsive')
  end

  scenario "ページネーションの改善されたスタイルが適用される" do
    # 6件以上のタスクを作成してページネーションを表示させる
    create_list(:task, 8, user: user)
    visit tasks_path

    # ページネーションが表示されることを確認
    expect(page).to have_css('.pagination')

    # ページネーションリンクが表示されることを確認
    within('.pagination') do
      expect(page).to have_css('li a, li span')
    end
  end
end