class FavoritesController < ApplicationController
  before_action :set_child, only: %i[create destroy]
  before_action :set_recording, only: %i[create destroy]

  def create
    current_user.favorites.find_or_create_by!(recording: @recording)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: child_recording_path(@child, @recording) }
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(recording: @recording)
    favorite&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: child_recording_path(@child, @recording) }
    end
  end

  def index
    @child = current_user.children.find(params[:child_id]).decorate
    @favorites = current_user.favorites
                             .joins(:recording)
                             .where(recordings: { child_id: @child.id })
                             .includes(recording: :child)
                             .order("recordings.recorded_at DESC")
                             .page(params[:page])
                             .per(5)
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def set_recording
    @recording = @child.recordings.find(params[:recording_id])
  end
end
