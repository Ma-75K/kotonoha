class RecordingsController < ApplicationController
  before_action :require_login
  before_action :set_child, except: [ :new ] # except: [:new]は一時的に追加しているため後で削除する

  def new
    @child = Child.find(params[:child_id]) # 一時的に追加しているため後で削除する
    @recording = @child.recordings.build
  end

  def create
    @recording = @child.recordings.build(recording_params)

    @recording.user = current_user #コメントアウト外した

    # 一時的に仮のユーザーを設定
    #@recording.user = User.first  # ← 一時的な対応

    @recording.title = "無題" if @recording.title.blank?

    if @recording.save
      render json: {
        success: true,
        message: "録音を保存しました",
        recording_id: @recording.id
      }, status: :created
    else
      render json: {
        success: false,
        errors: @recording.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def show
    @recording = @child.recordings.find(params[:id])
  end

  private

  def set_child
    # current_user を使わずに Child を取得
    @child = Child.find(params[:child_id]) # ←あとで削除
    # @child = current_user.children.find(params[:child_id]) ←あとでコメントアウト外す
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "アクセス権限がありません"
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
