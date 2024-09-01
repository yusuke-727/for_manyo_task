class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :correct_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = I18n.t('notices.account_created')
      session[:user_id] = @user.id  # これで新規登録後にログイン状態にする
      redirect_to tasks_path
    else
      flash.now[:alert] = "登録に失敗しました"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end  

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = I18n.t('notices.account_updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id]) 
    unless @user == current_user || current_user.admin?
      redirect_to tasks_path, alert: "管理者以外アクセスできません"
    end
  end
end
