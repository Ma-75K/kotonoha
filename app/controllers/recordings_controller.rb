class RecordingsController < ApplicationController
  before_action :require_login
  before_action :set_child
  before_action :set_recording, only: %i[show edit update destroy]

  def new
    @recording = @child.recordings.build

    @recent_recordings = @child.recordings
                                .order(recorded_at: :desc)
                                .limit(3)
  end

  def create
    @recording = @child.recordings.build(recording_params)
    @recording.user = current_user
    @recording.title = "無題" if @recording.title.blank?

    if @recording.save
      render json: {
        success: true,
        message: "録音を保存しました",
        recording_id: @recording.id
      }, status: :created
    else
      error_message = if @recording.errors[:duration].present?
        "録音が正しく保存されませんでした。もう一度録音してください。"
      else
        "保存に失敗しました。入力内容をご確認ください。"
      end

      render json: {
        success: false,
        message: error_message
      }, status: :unprocessable_entity
    end
  end

  def show
    @child = @child.decorate
  end

  def index
    @child = @child.decorate
    @recordings = @child.recordings
                        .order(recorded_at: :desc)
                        .page(params[:page])
                        .per(5)
  end

  def edit; end

  def update
    if @recording.update(recording_params)
      redirect_to child_recording_path(@child, @recording), notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recording.destroy
    redirect_to child_recordings_path(@child), alert: "削除しました"
  end

  def on_this_day
    @child = @child.decorate
    @target_date = Date.current.prev_year

    @recordings = @child.recordings
                        .where(recorded_at: @target_date.all_day)
                        .order(recorded_at: :desc)
                        .page(params[:page])
                        .per(5)
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "アクセス権限がありません"
  end

  def set_recording
    @recording = @child.recordings.find(params[:id])
  end

  def recording_params
    params.require(:recording).permit(
      :title,
      :comment,
      :recorded_at,
      :duration,
      :audio
    )
  end
end
