class Task < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validates :priority, presence: true

  # デフォルト値の設定
  after_initialize :set_defaults

  private

  def set_defaults
    self.status ||= "新規"
    self.priority ||= "中"
  end
end
