class SettingsController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @children = current_user.children.order(:created_at)
  end
end
