class SendResetPasswordInstructionsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    user.generate_reset_password_token!
    UserMailer.reset_password_email(user).deliver_now
  end
end
