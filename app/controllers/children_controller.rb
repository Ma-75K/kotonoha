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
    @child = @user.children.build
  end

  def create
    # session からユーザー情報を取得
    unless session[:user_params]
      flash[:danger] = "ユーザー情報が見つかりません"
      redirect_to new_user_path
      return
    end

    # ユーザーと子どもを作成
    @user = User.new(session[:user_params])
    @child = @user.children.build(child_params)

    # トランザクションで両方を保存
    ActiveRecord::Base.transaction do
      @user.save!
      @child.save!

      # ログイン処理
      auto_login(@user)

      # session をクリア
      session.delete(:user_params)

      flash[:success] = "登録が完了しました"
      redirect_to new_child_recording_path(@child)
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:danger] = "お子様の登録に失敗しました"
    render :new, status: :unprocessable_entity
  end

  private

  def child_params
    params.require(:child).permit(:name, :birthday)
  end
end
