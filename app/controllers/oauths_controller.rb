class OauthsController < ApplicationController
  skip_before_action :require_login, only: %i[callback failure]

  def callback
    auth = request.env["omniauth.auth"]

    user = User.find_or_initialize_by(
      provider: auth.provider,
      uid: auth.uid
    )

    if user.new_record?
      password = SecureRandom.hex(16)
      uid = auth.uid.to_s

      user.name = auth.info.name.presence || "LINEユーザー"
      user.email = auth.info.email.presence || "line_#{uid}@line.local"
      user.password = password
      user.password_confirmation = password
      user.save!
    end

    auto_login(user)

    if user.children.exists?
      child = user.children.first
      session[:current_child_id] = child.id
      redirect_to new_child_recording_path(child), flash: { success: "LINEログインしました" }
    else
      session[:from_line_login] = true
      redirect_to new_from_settings_children_path, flash: { success: "LINEログインしました。お子さま情報を登録してください" }
    end
  end

  def failure
    redirect_to login_path, flash: { alert: "LINEログインに失敗しました" }
  end
end
