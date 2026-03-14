class ApplicationController < ActionController::Base
  before_action :require_login
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  helper_method :current_child
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def not_authenticated
    flash[:alert] = "ログインしてください"
    redirect_to login_path
  end

  def record_not_found
    redirect_to root_path, alert: "指定されたデータが見つかりませんでした"
  end

  def require_user_session
    unless session[:user_id]
      redirect_to new_user_path, alert: "最初から登録してください"
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  # ヘッダーの表示を切り替えるメソッド
  def use_simple_header?
    !logged_in?
  end
  helper_method :use_simple_header?

  def current_child
    return nil unless logged_in?
    return nil unless session[:current_child_id]

    @current_child ||= current_user.children.find_by(id: session[:current_child_id])
  end
end
