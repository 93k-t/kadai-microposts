class Micropost < ApplicationRecord
  validates :content, presence: true, length: {maximum: 255}
  
  belongs_to :user
  # favorites テーブルとの一対多
  has_many :favorites
  # favorites テーブルを経由して user のデータを取得
  has_many :favoritings, through: :favorites, source: :user
end
