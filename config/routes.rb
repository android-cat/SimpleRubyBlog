# Railsアプリケーションのルーティング設定
Rails.application.routes.draw do
  # Deviseによる認証ルート
  devise_for :users

  # ルートパスの設定（トップページ）
  root 'posts#index'

  # 公開ブログ記事のルート
  resources :posts, only: [:index, :show]

  # 管理画面のルート（認証が必要）
  namespace :admin do
    resources :posts, except: [:show]
  end
end
