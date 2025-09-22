# coding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: "テストユーザー", email: "test@example.com",
                        password: "password", password_confirmation: "password") }

  subject { user }

  describe "バリデーション" do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_digest) }
    it { should respond_to(:authenticate) }
    it { should respond_to(:admin) }
    it { should respond_to(:admin?) }
    it { should respond_to(:tasks) }

    it { should be_valid }
    it { should_not be_admin }

    describe "管理者権限" do
      before do
        user.save!
        user.toggle!(:admin)
      end

      it { should be_admin }
    end

    describe "admin属性" do
      it "デフォルトではfalseであること" do
        expect(user.admin).to be_falsy
      end

      it "admin?メソッドが正しく動作すること" do
        expect(user.admin?).to be_falsy
        user.admin = true
        expect(user.admin?).to be_truthy
      end
    end

    describe "名前" do
      describe "が空の場合" do
        before { user.name = " " }
        it { should_not be_valid }
      end

      describe "が長すぎる場合" do
        before { user.name = "a" * 51 }
        it { should_not be_valid }
      end
    end

    describe "メールアドレス" do
      describe "が空の場合" do
        before { user.email = " " }
        it { should_not be_valid }
      end

      describe "フォーマットが正しくない場合" do
        it "無効であること" do
          addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                         foo@bar_baz.com foo@bar+baz.com]
          addresses.each do |invalid_address|
            user.email = invalid_address
            expect(user).not_to be_valid
          end
        end
      end

      describe "フォーマットが正しい場合" do
        it "有効であること" do
          addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
          addresses.each do |valid_address|
            user.email = valid_address
            expect(user).to be_valid
          end
        end
      end

      describe "が重複している場合" do
        before do
          user_with_same_email = user.dup
          user_with_same_email.email = user.email.upcase
          user_with_same_email.save
        end

        it { should_not be_valid }
      end
    end

    describe "パスワード" do
      describe "が空の場合" do
        before { user.password = user.password_confirmation = " " }
        it { should_not be_valid }
      end

      describe "が短すぎる場合" do
        before { user.password = user.password_confirmation = "a" * 5 }
        it { should be_invalid }
      end
    end
  end

  describe "メソッド" do
    describe "authenticated?" do
      before { user.save }
      let(:remember_token) { User.new_token }

      describe "remember_digestが空の場合" do
        it "falseを返すこと" do
          expect(user.authenticated?(remember_token)).to be_falsy
        end
      end
    end
  end

  describe "関連" do
    before do
      user.save
      @task1 = user.tasks.create!(title: "タスク1", description: "内容1")
      @task2 = user.tasks.create!(title: "タスク2", description: "内容2")
    end

    it "ユーザーが削除されたらタスクも削除されること" do
      tasks = user.tasks.to_a
      user.destroy
      expect(tasks).not_to be_empty
      tasks.each do |task|
        expect(Task.where(id: task.id)).to be_empty
      end
    end
  end
end