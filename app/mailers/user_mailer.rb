class UserMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(token: user.reset_password_token)

    mail(
      to: user.email,
      subject: "【ことのは】パスワード再設定のご案内"
    )
  end
end
