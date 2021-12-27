class User < ApplicationRecord
  before_save{self.email.downcase!}
  # self.email.downcase! 小文字に変換し保存
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
# format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i} メールアドレスが正しい形式か判断する(正規表現)
                    uniqueness:{case_sensitive: false}
# uniqueness 重複を許さない
  has_secure_password
  has_many :microposts
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name:"Relationship", foreign_key: "follow_id"
  has_many :followers, through: :reverses_of_relationship, source: :user
  # favorites テーブルとの一対多
  has_many :favorites
  # favorites テーブルを経由して micropost のデータを取得
  has_many :favoritings, through: :favorites, source: :micropost
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # 中間テーブル favorites へデータの登録/削除するメソッド
  def favorite(other_micropost)
    self.favorites.find_or_create_by(micropost_id: other_micropost.id)
  end
  
  def unfavorite(other_micropost)
    favorite = self.favorites.find_by(micropost_id: other_micropost.id)
    favorite.destroy if favorite
  end
  
  # 既にお気に入り登録済みか調べるメソッド
  def favoriting?(other_micropost)
    self.favoritings.include?(other_micropost)
  end
end