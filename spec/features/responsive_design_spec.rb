require 'rails_helper'

RSpec.feature "レスポンシブデザイン", type: :feature do
  let(:user) { create(:user) }

  before do
    login_user(user)
  end

  scenario "モバイル画面サイズでビューポート設定が適用されている" do
    visit tasks_path

    # ビューポート設定の確認（DOM内に存在することを確認）
    expect(page).to have_css('meta[name="viewport"][content="width=device-width, initial-scale=1"]', visible: false)
  end

  scenario "タスク一覧がモバイルで適切に表示される" do
    # テスト用のタスクを作成
    create_list(:task, 3, user: user)

    # ウィンドウサイズをモバイルサイズに変更
    page.driver.browser.manage.window.resize_to(375, 667) # iPhone 6/7/8 サイズ

    visit tasks_path

    # タスクアイテムが表示されることを確認
    expect(page).to have_css('.task-item', count: 3)

    # 新規作成ボタンが表示されることを確認
    expect(page).to have_link('新規タスク作成')
  end

  scenario "フォームがモバイルで適切に表示される" do
    # ウィンドウサイズをモバイルサイズに変更
    page.driver.browser.manage.window.resize_to(375, 667)

    visit new_task_path

    # フォーム要素が表示されることを確認
    expect(page).to have_field('task_title')
    expect(page).to have_field('task_description')
    expect(page).to have_field('task_status')
    expect(page).to have_field('task_priority')
    expect(page).to have_field('task_due_date')

    # ボタンが表示されることを確認
    expect(page).to have_button('タスクを作成')
    expect(page).to have_link('キャンセル')
  end

  scenario "タブレット画面サイズで適切に表示される" do
    # テスト用のタスクを作成
    create_list(:task, 8, user: user)

    # ウィンドウサイズをタブレットサイズに変更
    page.driver.browser.manage.window.resize_to(768, 1024) # iPad サイズ

    visit tasks_path

    # タスクが適切に表示される（最初の5件）
    expect(page).to have_css('.task-item', count: 5)

    # ページネーションが表示される
    expect(page).to have_css('.pagination')
  end

  scenario "デスクトップ画面サイズで適切に表示される" do
    # テスト用のタスクを作成
    create_list(:task, 8, user: user)

    # ウィンドウサイズをデスクトップサイズに変更
    page.driver.browser.manage.window.resize_to(1200, 800)

    visit tasks_path

    # タスクが適切に表示される
    expect(page).to have_css('.task-item', count: 5)

    # ページネーションが表示される
    expect(page).to have_css('.pagination')

    # 詳細ボタンがすべて表示されている
    expect(page).to have_link('詳細', count: 5)
    expect(page).to have_link('編集', count: 5)
    expect(page).to have_link('削除', count: 5)
  end
end