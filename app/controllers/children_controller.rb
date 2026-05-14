class ChildrenController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    unless session[:user_params]
      flash[:alert] = "ユーザー情報が見つかりません"
      redirect_to new_user_path
      return
    end
    # 一時的な User オブジェクトを作成（DB には保存しない）
    @user = User.new(session[:user_params])
    @user.children.build if @user.children.empty?
    # @child = @user.children.build
  end

  def create
    unless session[:user_params]
      flash[:alert] = "ユーザー情報が見つかりません"
      redirect_to new_user_path
      return
    end

    @form = UserRegistrationForm.new(
      user_params: session[:user_params],
      children_params: user_children_params[:children_attributes]
    )

    if @form.save
      auto_login(@form.user)
      session.delete(:user_params)
      session[:current_child_id] = @form.user.children.first.id

      flash[:success] = "登録が完了しました"
      redirect_to new_child_recording_path(session[:current_child_id])
    else
      @user = @form.user
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @child = current_user.children.find(params[:id])
  end

  def update
    @child = current_user.children.find(params[:id])

    if @child.update(child_params)
      flash[:success] = "お子さま情報を更新しました"
      redirect_to settings_path
    else
      flash.now[:alert] = "お子さま情報を更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @child = current_user.children.find(params[:id])

    if current_user.children.count == 1
      flash[:alert] = "最後のお子さまは削除できません"
      redirect_to edit_child_path(@child)
      return
    end

    delete_child_id = @child.id

    if @child.destroy
      if session[:current_child_id] == delete_child_id
        next_child = current_user.children.first
        session[:current_child_id] = next_child&.id
      end

      flash[:success] = "お子さま情報を削除しました"
    else
      flash[:alert] = "お子さま情報を削除できませんでした"
    end

    redirect_to settings_path
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

  def new_from_settings
    @child = current_user.children.build
  end

  def create_from_settings
    @child = current_user.children.build(child_params)

    if @child.save
      flash[:success] = "お子さまを追加しました"
      redirect_to settings_path
    else
      flash.now[:alert] = "お子さまを追加できませんでした"
      render :new_from_settings, status: :unprocessable_entity
    end
  end

  private

  def user_children_params
    params.require(:user).permit(
      children_attributes: [ :name, :birthday ]
    )
  end

  def child_params
    params.require(:child).permit(:name, :birthday)
  end
end
