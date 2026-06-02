class PasswordResetsController < ApplicationController
  skip_before_action :require_login, only: %i[edit update]

  def new
    @email = current_user&.email
  end

  def create
    @email = params[:email].to_s.strip

    if @email.blank?
      flash.now[:alert] = "入力内容をご確認ください"
      render :new, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: @email)

    if user
      SendResetPasswordInstructionsJob.perform_now(user.id)
    end

    flash[:success] = "パスワード再設定メールを送信しました"
    redirect_to new_password_reset_path
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

    if @user.password.blank?
      @user.errors.add(:password, "を入力してください")
    end

    if @user.password_confirmation.blank?
      @user.errors.add(:password_confirmation, "を入力してください")
    end

    if @user.errors.any?
      flash.now[:alert] = "入力内容をご確認ください"
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.save
      @user.update_columns(
        reset_password_token: nil,
        reset_password_token_expires_at: nil
      )
      flash[:success] = "パスワードを変更しました"
      redirect_to login_path
    else
      flash.now[:alert] = "入力内容をご確認ください"
      render :edit, status: :unprocessable_entity
    end
  end
end
