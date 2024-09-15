FactoryBot.define do
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { Date.today }
    priority { 'medium' }
    status { 'not_started' }
    association :user  # ユーザーとの関連を追加
  end

  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { Date.today + 1.day }
    priority { 'high' }
    status { 'in_progress' }
    association :user  # ユーザーとの関連を追加
  end

  factory :third_task, class: Task do
    title { '会議準備' }
    content { '会議の資料を準備する。' }
    deadline_on { Date.today + 2.days }
    priority { 'low' }
    status { 'done' }
    association :user  # ユーザーとの関連を追加
  end
end
