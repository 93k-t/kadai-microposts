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
end
