# db/migrate/20251029000002_create_posts.rb
# ブログ投稿テーブルの作成

class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      # タイトル（必須）
      t.string :title, null: false
      
      # 本文（Markdown形式、必須）
      t.text :content, null: false
      
      # 投稿者（ユーザーとの関連）
      t.references :user, null: false, foreign_key: true

      # 作成日時・更新日時
      t.timestamps
    end

    # インデックスの追加（作成日時の降順で検索を高速化）
    add_index :posts, :created_at
  end
end
