class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update]
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
    # @user は set_user で設定されています
  end

  def edit
    # @user は set_user で設定されています
  end

  def update
    # @user は set_user で設定されています
    if @user.update(user_params)
      flash[:notice] = I18n.t('notices.account_updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    unless @user == current_user || current_user.admin?
      redirect_to tasks_path, alert: "管理者以外アクセスできません"
    end
  end
end
