# app/controllers/posts_controller.rb
# 公開ページのブログ投稿コントローラー

class PostsController < ApplicationController
  # トップページ（投稿一覧）
  def index
    @posts = Post.recent.includes(:user)
  end

  # 記事詳細ページ
  def show
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '記事が見つかりませんでした。'
  end
end
