# 開発環境の設定
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # 開発環境ではクラスの変更を自動リロード
  config.cache_classes = false

  # Eager loadingを無効化（開発環境）
  config.eager_load = false

  # エラーを画面に表示
  config.consider_all_requests_local = true

  # サーバーのタイミング情報をブラウザに送信
  config.server_timing = true

  # キャッシュの設定
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Active Storageの設定
  config.active_storage.service = :local

  # メール配信設定（開発環境）
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # ロケールファイルの変更を検知
  config.i18n.raise_on_missing_translations = true

  # アセットのデバッグを有効化
  config.assets.debug = true
  config.assets.quiet = true

  # ログレベル
  config.log_level = :debug

  # Active Recordの設定
  config.active_record.verbose_query_logs = true
  config.active_record.migration_error = :page_load
end
