class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    if logged_in?
      flash[:alert] = I18n.t('notices.logout_required')
      redirect_to tasks_path
    else
      # ログインページの表示処理
    end
  end

  def create
    if params[:session].nil? || params[:session][:email].blank?
      flash.now[:alert] = I18n.t('activerecord.errors.models.user.attributes.email.blank')
      render 'new'
      return
    end
  
    if params[:session][:password].blank?
      flash.now[:alert] = I18n.t('activerecord.errors.models.user.attributes.password.blank')
      render 'new'
      return
    end
  
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = I18n.t('notices.logged_in')
      redirect_to tasks_path
    else
      flash.now[:alert] = I18n.t('notices.login_failed')
      render 'new'
    end
  end
  

  def destroy
    session[:user_id] = nil
    flash[:notice] = I18n.t('notices.logged_out')
    redirect_to new_session_path
  end
end
