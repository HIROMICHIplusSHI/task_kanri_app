require 'rails_helper'

RSpec.feature "User Login" do
  scenario "user can log in with valid credentials" do
    # Given: ユーザーが存在する
    user = create(:user)

    # When: トップページにアクセスしてログインフォームに入力
    visit root_path
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    click_button "ログイン"

    # Then: ログインに成功する
    expect(page).to have_content(user.name)
    expect(current_path).to eq(user_path(user))
  end
end