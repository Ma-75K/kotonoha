class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @email = params[:email]
    @email_error = "メールアドレスを入力してください" if params[:email].blank?
    @password_error = "パスワードを入力してください" if params[:password].blank?

    if @email_error.present? || @password_error.present?
      render :new, status: :unprocessable_entity
      return
    end

    @user = login(params[:email], params[:password])

    if @user
      session[:current_child_id] = @user.children.first.id unless session[:current_child_id]
      redirect_to new_child_recording_path(current_child), success: "ログインしました"
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
