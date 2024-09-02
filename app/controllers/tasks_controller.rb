class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks.search(params).sorted(params).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('views.tasks.flash.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('views.tasks.flash.update')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('views.tasks.flash.destroy')
  end

  private

  def require_login
    unless logged_in?
      redirect_to new_session_path, alert: 'ログインしてください'
    end
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def authorize_user
    unless current_user.admin? || @task.user == current_user
      redirect_to tasks_path, alert: t('notices.unauthorized_access')
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: 'タスクが見つかりません'
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end
