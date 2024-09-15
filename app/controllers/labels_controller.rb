class LabelsController < ApplicationController
    before_action :set_label, only: [:edit, :update, :destroy]
    before_action :require_login

  
    def index
      @labels = Label.all
    end
  
    def new
      @label = Label.new
    end
  
    def create
      @label = current_user.labels.build(label_params)
      if @label.save
        redirect_to labels_path, notice: 'ラベルを登録しました'
      else
        render :new
      end
    end

    def edit
    end
  
    def update
      if @label.update(label_params)
        redirect_to labels_path, notice: 'ラベルを更新しました'
      else
        render :edit
      end
    end
  
    def destroy
      @label.destroy
      redirect_to labels_path, notice: 'ラベルを削除しました'
    end
  
    private
  
    def set_label
      @label = Label.find(params[:id])
    end
  
    def label_params
      params.require(:label).permit(:name)
    end

    def correct_user_label
      @label = current_user.labels.find_by(id: params[:id])
      redirect_to labels_path, alert: "不正な操作です" if @label.nil?
    end
  end
  