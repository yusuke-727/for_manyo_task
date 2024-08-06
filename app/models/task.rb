class Task < ApplicationRecord
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, done: 2 }

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # 検索とソートのスコープを追加
  scope :search, ->(params) {
    tasks = all
    if params[:search].present?
      if params[:search][:title].present?
        puts "検索条件: タイトル = #{params[:search][:title]}"
        tasks = tasks.where("title LIKE ?", "%#{params[:search][:title]}%")
        puts "SQLクエリ: #{tasks.to_sql}"
      end
      if params[:search][:status].present?
        puts "検索条件: ステータス = #{params[:search][:status]}"
        tasks = tasks.where(status: params[:search][:status])
        puts "SQLクエリ: #{tasks.to_sql}"
      end
    end
    tasks
  }

  scope :sorted, ->(params) {
    if params[:sort_deadline_on]
      order(deadline_on: :asc)
    elsif params[:sort_priority]
      order(priority: :desc, created_at: :desc)  # 優先度の降順と作成日時の降順
    else
      order(created_at: :desc)
    end
  }
end
