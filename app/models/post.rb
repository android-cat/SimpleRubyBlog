# app/models/post.rb
# ブログ投稿モデル

class Post < ApplicationRecord
  # ユーザーとの関連（多対1）
  belongs_to :user

  # バリデーション
  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true

  # スコープ：作成日時の降順で並べ替え
  scope :recent, -> { order(created_at: :desc) }

  # Markdownを HTMLに変換するメソッド
  def content_html
    renderer = Redcarpet::Render::HTML.new(
      filter_html: false,
      hard_wrap: true,
      link_attributes: { target: '_blank' }
    )
    
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true
    )
    
    markdown.render(content).html_safe
  end
end
