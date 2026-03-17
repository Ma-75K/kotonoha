class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

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

      flash[:success] = "ユーザー情報を登録しました。お子様の情報を入力してください"
      redirect_to new_child_path
    else
      flash.now[:danger] = "入力内容に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
