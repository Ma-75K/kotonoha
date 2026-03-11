class ChildrenController < ApplicationController
  before_action :require_user_session

  def new
    @child = current_user.children.build
  end

  def create
    @child = current_user.children.build(child_params)

    if @child.save
      session.delete(:user_params)
      flash[:success] = "お子さま情報の登録が完了しました"
      redirect_to new_child_recording_path(@child)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def child_params
    params.require(:child).permit(:name, :birthday)
  end
end
