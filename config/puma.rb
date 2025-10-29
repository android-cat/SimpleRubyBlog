# Pumaサーバーの設定

# Pumaが使用するスレッド数の最小値と最大値
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Pumaが使用するワーカー数（本番環境用）
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# サーバーのポート番号
port ENV.fetch("PORT") { 3000 }

# 環境の設定
environment ENV.fetch("RAILS_ENV") { "development" }

# サーバーのPIDファイルの場所
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# 本番環境でのワーカー数
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# プリロード機能（本番環境で有効化）
# preload_app!

# プラグインの読み込み
plugin :tmp_restart
