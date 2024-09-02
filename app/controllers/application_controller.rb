class ApplicationController < ActionController::Base
  before_action :require_login, except: [:new, :create]
  before_action :redirect_logged_in_user, if: :logged_in?, only: [:new, :create]

  private

  def require_login
    unless logged_in?
      flash[:alert] = "ログインしてください"
      redirect_to new_session_path
    end
  end

  def redirect_logged_in_user
    if request.path == new_user_path || request.path == new_session_path
      flash[:alert] = "ログアウトしてください"
      redirect_to tasks_path
    end
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end
end
