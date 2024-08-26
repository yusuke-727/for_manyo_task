module Admin
    class BaseController < ApplicationController
      before_action :require_admin
  
      private
  
      def require_admin
        unless current_user&.admin?
          redirect_to tasks_path, alert: '管理者以外アクセスできません'
        end
      end
    end
  end
  