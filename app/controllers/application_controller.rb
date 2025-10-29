# app/controllers/application_controller.rb
# 全てのコントローラーの基底クラス

class ApplicationController < ActionController::Base
  # CSRF対策のトークン検証を有効化
  protect_from_forgery with: :exception
  
  # デフォルトのロケールを日本語に設定
  before_action :set_locale
  
  private
  
  # ロケールの設定
  def set_locale
    I18n.locale = :ja
  end
end
