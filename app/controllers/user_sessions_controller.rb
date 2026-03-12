class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      session[:user_id] = @user.id

      child = @user.children.first

      if child
        redirect_to new_child_recording_path(child), success: "ログインしました"
      else
        redirect_to new_child_path, alert: "お子さまを登録してください"
      end
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    session[:user_id] = nil
    flash[:success] = "ログアウトしました"
    redirect_to root_path
  end
end
