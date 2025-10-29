# app/models/user.rb
# ユーザーモデル（管理者）

class User < ApplicationRecord
  # Deviseモジュールの設定
  # :database_authenticatable - データベース認証
  # :registerable - ユーザー登録
  # :recoverable - パスワードリセット
  # :rememberable - ログイン記憶
  # :validatable - バリデーション
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ブログ投稿との関連（1対多）
  has_many :posts, dependent: :destroy

  # バリデーション
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end
