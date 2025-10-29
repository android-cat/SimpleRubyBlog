# app/controllers/admin/posts_controller.rb
# 管理画面のブログ投稿コントローラー

module Admin
  class PostsController < Admin::BaseController
    before_action :set_post, only: [:edit, :update, :destroy]

    # 投稿一覧
    def index
      @posts = Post.recent.includes(:user)
    end

    # 新規投稿フォーム
    def new
      @post = Post.new
    end

    # 投稿作成
    def create
      @post = current_user.posts.build(post_params)
      
      if @post.save
        redirect_to admin_posts_path, notice: '投稿を作成しました。'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # 投稿編集フォーム
    def edit
    end

    # 投稿更新
    def update
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: '投稿を更新しました。'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # 投稿削除
    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: '投稿を削除しました。'
    end

    private

    # 投稿を取得
    def set_post
      @post = Post.find(params[:id])
    end

    # Strong Parameters
    def post_params
      params.require(:post).permit(:title, :content)
    end
  end
end
