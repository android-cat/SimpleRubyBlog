# 本番環境の設定
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # クラスのキャッシュを有効化
  config.cache_classes = true

  # Eager loadingを有効化
  config.eager_load = true

  # 本番環境ではエラー画面を表示しない
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # 公開ファイルサーバーの設定
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # アセットのコンパイル
  config.assets.compile = false

  # Active Storageの設定
  config.active_storage.service = :local

  # ログレベル
  config.log_level = :info

  # ログのフォーマット
  config.log_tags = [ :request_id ]

  # キャッシュストア
  config.cache_store = :memory_store

  # メール配信設定
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'your-domain.com' }

  # 国際化のフォールバック
  config.i18n.fallbacks = true

  # 非推奨警告を無効化
  config.active_support.report_deprecations = false

  # Active Recordの設定
  config.active_record.dump_schema_after_migration = false
end
