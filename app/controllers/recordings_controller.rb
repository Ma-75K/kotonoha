class RecordingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child
  def new
    @recording = @child.recordings.build
  end

  def create
    @recording = @child.recordings.build(recording_params)
    @recording.user = current_user

    if @recording.save
      render json: {
        success: true,
        message: '録音を保存しました',
        recording_id: @recording.id
      }, status: :created
    else
      render json: {
        success: false,
        errors: @recording.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'アクセス権限がありません'
  end

  def recording_params
    params.require(:recording).permit(
      :title,
      :comment,
      :recorded_at,
      :duration,
      :audio_file
    )
  end
end
