# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
    before_action :require_login, except: [:new, :create]
  
    private
  
    def require_login
      unless logged_in?
        flash[:alert] = "ログインしてください"
        redirect_to login_path
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
  