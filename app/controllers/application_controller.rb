class ApplicationController < ActionController::Base
  before_action :require_login

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  # Sorceryのログイン失敗時の処理
  def not_authenticated
    flash[:alert] = "ログインしてください"
    redirect_to login_path
  end

  # 404エラー時の処理
  def record_not_found
    redirect_to root_path, alert: "指定されたデータが見つかりませんでした"
  end

  # ヘッダーの表示を切り替えるメソッド
  def use_simple_header?
    !logged_in?
  end
  helper_method :use_simple_header?

  # 現在選択されているお子様を取得
  def current_child
    return nil unless logged_in?

    @current_child ||= if session[:current_child_id]
                         # セッションにIDがある場合、そのお子様を取得
                         current_user.children.find_by(id: session[:current_child_id]) || current_user.children.first
                       else
                         # セッションにIDがない場合、最初のお子様を取得
                         current_user.children.first
                       end
  end
  helper_method :current_child
end
