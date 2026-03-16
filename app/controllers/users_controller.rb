class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
    if session[:user_params]
      @user.assign_attributes(session[:user_params])
    end
  end

  def create
    @user = User.new(user_params)

    # デバック用のログ出力
    Rails.logger.debug "User params: #{user_params.inspect}"
    Rails.logger.debug "User valid?: #{@user.valid?}"
    Rails.logger.debug "User errors: #{@user.errors.full_messages}" unless @user.valid?

    if @user.save
       # 一時的にユーザーIDをセッションに保存
      session[:temp_user_id] = @user.id

      flash[:success] = "登録が完了しました"
      redirect_to new_child_path
    else
      flash[:danger] = "ユーザー登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
