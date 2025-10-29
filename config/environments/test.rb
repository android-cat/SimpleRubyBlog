# テスト環境の設定
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # クラスのキャッシュを有効化（テスト用）
  config.cache_classes = true

  # Eager loadingを無効化
  config.eager_load = false

  # テスト環境の設定
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # エラーを表示
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # 例外を発生させる
  config.action_dispatch.show_exceptions = false

  # CSRFトークンの無効化
  config.action_controller.allow_forgery_protection = false

  # Active Storageの設定
  config.active_storage.service = :test

  # メール配信設定
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # 非推奨警告を表示
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
end
