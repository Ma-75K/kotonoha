class FavoritesController < ApplicationController
  before_action :set_child
  before_action :set_recording

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

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def set_recording
    @recording = @child.recordings.find(params[:recording_id])
  end
end
