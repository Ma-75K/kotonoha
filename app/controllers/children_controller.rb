class ChildrenController < ApplicationController
  # 登録中は認証をスキップ
  skip_before_action :require_login, only: %i[new create]

  def new
    # session からユーザー情報を取得
    unless session[:user_params]
      flash[:danger] = "ユーザー情報が見つかりません"
      redirect_to new_user_path
      return
    end

    # 一時的な User オブジェクトを作成（DB には保存しない）
    @user = User.new(session[:user_params])
    @user.children.build
  end

  def create
    Rails.logger.debug "=== params ==="
    Rails.logger.debug params.inspect
    # session からユーザー情報を取得
    unless session[:user_params]
      flash[:danger] = "ユーザー情報が見つかりません"
      redirect_to new_user_path
      return
    end

    # ユーザーと子どもを作成
    @user = User.new(session[:user_params])
    @user.assign_attributes(user_children_params)

    # トランザクションで両方を保存
    ActiveRecord::Base.transaction do
      @user.save!

      # ログイン処理
      auto_login(@user)
      # session をクリア
      session.delete(:user_params)

      session[:current_child_id] = @user.children.first.id


      flash[:success] = "登録が完了しました"
      redirect_to new_child_recording_path(session[:current_child_id])
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:danger] = "登録に失敗しました: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  def switch
    @child = current_user.children.find(params[:id])
    session[:current_child_id] = @child.id

    flash[:success] = "#{@child.name}さんに切り替えました"
    redirect_to new_child_recording_path(@child.id)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "お子様が見つかりませんでした"
    redirect_to root_path
  end

  private

  def user_children_params
    params.require(:user).permit(
      children_attributes: [:name, :birthday]
    )
  end
end
