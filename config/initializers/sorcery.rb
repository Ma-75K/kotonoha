# The first thing you need to configure is which modules you need in your app.
# The default is nothing which will include only core features (password encryption, login/logout).
#
# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection, :activity_logging,
# :magic_login, :external
Rails.application.config.sorcery.submodules = [ :reset_password ]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.reset_password_mailer = UserMailer
    user.reset_password_email_method_name = :reset_password_email
    user.reset_password_expiration_period = 2.hours
  end
  config.user_class = "User"
end
