require 'rails_helper'

RSpec.describe Task do
  describe 'validations' do
    let(:user) { create(:user) }

    context 'title validation' do
      it 'requires a title' do
        task = build(:task, user: user, title: nil)
        expect(task).not_to be_valid
        expect(task.errors[:title]).to include("を入力してください")
      end

      it 'requires title to be 100 characters or less' do
        task = build(:task, user: user, title: 'a' * 101)
        expect(task).not_to be_valid
        expect(task.errors[:title]).to include("は100文字以内で入力してください")
      end

      it 'accepts valid title' do
        task = build(:task, user: user, title: 'Valid title')
        expect(task).to be_valid
      end
    end

    context 'description validation' do
      it 'requires a description' do
        task = build(:task, user: user, description: nil)
        expect(task).not_to be_valid
        expect(task.errors[:description]).to include("を入力してください")
      end

      it 'requires a description to not be empty' do
        task = build(:task, user: user, description: '')
        expect(task).not_to be_valid
        expect(task.errors[:description]).to include("を入力してください")
      end

      it 'requires description to be 500 characters or less' do
        task = build(:task, user: user, description: 'a' * 501)
        expect(task).not_to be_valid
        expect(task.errors[:description]).to include("は500文字以内で入力してください")
      end

      it 'accepts valid description' do
        task = build(:task, user: user, description: 'This is a valid description')
        expect(task).to be_valid
      end
    end

    context 'status validation' do
      it 'requires a status' do
        task = build(:task, user: user, status: nil)
        expect(task).not_to be_valid
        expect(task.errors[:status]).to include("を入力してください")
      end
    end

    context 'priority validation' do
      it 'requires a priority' do
        task = build(:task, user: user, priority: nil)
        expect(task).not_to be_valid
        expect(task.errors[:priority]).to include("を入力してください")
      end
    end
  end

  describe 'default values' do
    let(:user) { create(:user) }

    it 'sets default status to "新規"' do
      task = Task.new(user: user, title: 'Test', description: 'Test description')
      expect(task.status).to eq('新規')
    end

    it 'sets default priority to "中"' do
      task = Task.new(user: user, title: 'Test', description: 'Test description')
      expect(task.priority).to eq('中')
    end
  end
end