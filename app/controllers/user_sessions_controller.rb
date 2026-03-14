class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      child = @user.children.first

      if child
        session[:current_child_id] = child.id
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
    session[:current_child_id] = nil
    flash[:success] = "ログアウトしました"
    redirect_to root_path, status: :see_other
  end
end
