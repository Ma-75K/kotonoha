class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new confirm]

  def new
    @user = User.new

    # 戻るボタンで戻ってきた場合、入力内容を復元
    if session[:user_params]
      @user.assign_attributes(session[:user_params])
    end
  end

  def confirm
    @user = User.new(user_params)

    # バリデーションチェック
    if @user.valid?
      # sessionに一時保存
      session[:user_params] = user_params.to_h
      render :confirm
    else
      flash.now[:danger] = "入力内容に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  def edit_name
    @user = current_user
  end

  def update_name
    @user = current_user

    if @user.update(name_params)
      flash[:success] = "お名前を変更しました"
      redirect_to settings_path
    else
      flash.now[:alert] = "お名前を変更できませんでした"
      render :edit_name, status: :unprocessable_entity
    end
  end

  def edit_email
    @user = current_user
  end

  def update_email
    @user = current_user

    if @user.update(email_params)
      flash[:success] = "メールアドレスを変更しました"
      redirect_to settings_path
    else
      flash.now[:alert] = "メールアドレスを変更できませんでした"
      render :edit_email, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def name_params
    params.require(:user).permit(:name)
  end

  def email_params
    params.require(:user).permit(:email)
  end
end
