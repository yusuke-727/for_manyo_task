class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks.sorted(params).page(params[:page]).per(10)
    
    if params[:search].present?
      if params[:search][:title].present? && params[:search][:status].present?
        @tasks = @tasks.where("title LIKE ?", "%#{params[:search][:title]}%").where(status: params[:search][:status])
      elsif params[:search][:title].present?
        @tasks = @tasks.where("title LIKE ?", "%#{params[:search][:title]}%")
      elsif params[:search][:status].present?
        @tasks = @tasks.where(status: params[:search][:status])
      end
      
      if params[:search][:label].present?
        @tasks = @tasks.joins(:labels).where(labels: { id: params[:search][:label] })
      end
    end
  end


  def show
  end

  def new
    @task = current_user.tasks.build
    @labels = current_user.labels
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('views.tasks.flash.create')
    else
      Rails.logger.info("Task creation failed with errors: #{@task.errors.full_messages}")
      flash.now[:alert] = 'タスクの作成に失敗しました'
      render :new
    end
  end

  def edit
    @labels = current_user.labels 
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('views.tasks.flash.update')
    else
      Rails.logger.info("Label creation failed with errors: #{@label.errors.full_messages}")
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
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
  end
end
