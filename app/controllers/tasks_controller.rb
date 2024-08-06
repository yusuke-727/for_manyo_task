class TasksController < ApplicationController
  def index
    # 検索とソートの適用
    @tasks = Task.search(params).sorted(params).page(params[:page]).per(10)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('views.tasks.flash.create')
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('views.tasks.flash.update')
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: t('views.tasks.flash.destroy')
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end
