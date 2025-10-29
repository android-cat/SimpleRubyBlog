source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.0'

# Rails本体
gem 'rails', '~> 7.0.8'

# データベース
gem 'mysql2', '~> 0.5'

# Webサーバー
gem 'puma', '~> 5.0'

# アセットパイプライン
gem 'sprockets-rails'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'

# JSONビルダー
gem 'jbuilder'

# タイムゾーン情報
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

# 起動時間短縮
gem 'bootsnap', require: false

# 認証機能
gem 'devise'

# Markdown パーサー
gem 'redcarpet'

# シンタックスハイライト
gem 'rouge'

group :development, :test do
  # デバッグツール
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # コンソール
  gem 'web-console'
end
