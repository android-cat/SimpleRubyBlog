# app/controllers/admin/base_controller.rb
# 管理画面の基底コントローラー

module Admin
  class BaseController < ApplicationController
    # レイアウトを管理画面用に設定
    layout 'admin'
    
    # 認証が必要
    before_action :authenticate_user!
    
    # 管理画面へのアクセスログ
    before_action :log_admin_access
    
    private
    
    # 管理画面へのアクセスをログに記録
    def log_admin_access
      Rails.logger.info "Admin access: #{current_user.email} - #{controller_name}##{action_name}"
    end
  end
end
