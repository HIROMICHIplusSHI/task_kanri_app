require 'rails_helper'

RSpec.feature "国際化機能", type: :feature do
  scenario "言語切り替えリンクが表示される" do
    visit root_path
    expect(page).to have_link("English")
    expect(page).to have_link("日本語")
  end

  scenario "英語ロケールでページが表示される" do
    visit "/?locale=en"
    expect(page).to have_content("Task Management App")
    expect(page).to have_content("Sign Up")
  end

  scenario "日本語ロケールでページが表示される" do
    visit "/?locale=ja"
    expect(page).to have_content("タスク管理アプリ")
    expect(page).to have_content("アカウント作成")
  end
end