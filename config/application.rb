# Railsアプリケーションのルート設定
require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SimpleBlog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # タイムゾーンを日本時間に設定
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # ロケールを日本語に設定
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # アセットパイプラインの設定
    config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets')
  end
end
