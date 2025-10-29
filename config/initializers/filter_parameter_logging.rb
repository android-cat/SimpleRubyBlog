# config/initializers/filter_parameter_logging.rb
# パスワードなどの機密情報をログに出力しないようにフィルタリング

Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]
