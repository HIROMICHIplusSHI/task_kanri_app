require 'rails_helper'

RSpec.describe "タスクページネーション" do
  let(:user) { create(:user) }

  describe "will_paginate integration" do
    it "per_page設定が正しく動作する" do
      create_list(:task, 8, user: user)

      page1 = user.tasks.order(created_at: :desc).paginate(page: 1, per_page: 5)
      page2 = user.tasks.order(created_at: :desc).paginate(page: 2, per_page: 5)

      expect(page1.size).to eq(5)
      expect(page2.size).to eq(3)
      expect(page1.total_entries).to eq(8)
      expect(page1.total_pages).to eq(2)
    end

    it "空の場合でも正常に動作する" do
      paginated = user.tasks.order(created_at: :desc).paginate(page: 1, per_page: 5)

      expect(paginated.size).to eq(0)
      expect(paginated.total_entries).to eq(0)
      expect(paginated.total_pages).to eq(0)
    end

    it "存在しないページでも正常に動作する" do
      create_list(:task, 3, user: user)

      paginated = user.tasks.order(created_at: :desc).paginate(page: 10, per_page: 5)

      expect(paginated.size).to eq(0)
    end
  end
end