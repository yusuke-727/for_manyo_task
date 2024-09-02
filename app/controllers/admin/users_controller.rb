module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.includes(:tasks)
    end

    def show
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: t('views.users.flash.create')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "ユーザを更新しました"
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        flash[:notice] = 'ユーザを削除しました'
      else
        # ここでフラッシュメッセージを適切に設定します
        flash[:alert] = @user.errors.full_messages.join(', ')
      end
      redirect_to admin_users_path
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
  end
end
