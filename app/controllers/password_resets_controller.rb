class PasswordResetsController < ApplicationController
  skip_before_action :require_login, only: %i[edit update]

  def new
    @email = current_user&.email
  end

  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.deliver_reset_password_instructions!
    end

    redirect_to new_password_reset_path, notice: "パスワード再設定メールを送信しました"
  end

  def edit
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)

    unless @user
      redirect_to new_password_reset_path, alert: "無効または期限切れのリンクです"
      nil
    end
  end

  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)

    unless @user
      redirect_to new_password_reset_path, alert: "無効または期限切れのリンクです"
      return
    end

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      @user.update_columns(
        reset_password_token: nil,
        reset_password_token_expires_at: nil
      )
      flash[:success] = "パスワードを更新しました"
      redirect_to login_path
    else
      flash.now[:alert] = "パスワードを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end
end
