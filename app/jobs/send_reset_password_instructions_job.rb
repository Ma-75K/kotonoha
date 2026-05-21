class SendResetPasswordInstructionsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.deliver_reset_password_instructions!
  end
end
