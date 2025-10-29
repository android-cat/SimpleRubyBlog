# config/initializers/devise.rb
# Deviseの初期設定

Devise.setup do |config|
  # Secret keyの設定
  config.secret_key = 'your-secret-key-here-change-in-production'

  # メール送信者のアドレス
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # ORMの設定
  require 'devise/orm/active_record'

  # 認証キー（ログインに使用する属性）
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # パスワードの設定
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12

  # ログイン記憶の有効期限
  config.remember_for = 2.weeks

  # パスワードの有効期限
  config.expire_all_remember_me_on_sign_out = true

  # パスワードの長さ
  config.password_length = 6..128

  # メールアドレスの正規表現
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ログアウト後のリダイレクト先
  config.sign_out_via = :delete

  # タイムアウト設定
  # config.timeout_in = 30.minutes

  # ロック設定
  # config.lock_strategy = :failed_attempts
  # config.unlock_keys = [:email]
  # config.unlock_strategy = :both
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour
  # config.last_attempt_warning = true
end
