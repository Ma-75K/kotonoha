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
      auto_login(@user)
      # セッションにユーザーIDを保存（次の画面で使用）
      session[:user_id] = @user.id
      session[:user_params] = user_params.except(:password, :password_confirmation).to_h
      flash[:success] = "登録が完了しました"
      redirect_to new_child_path
    else
      session[:user_params] = user_params.except(:password, :password_confirmation).to_h
      flash[:danger] = "ユーザー登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
