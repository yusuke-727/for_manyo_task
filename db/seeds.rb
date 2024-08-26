# ユーザーを作成
user = User.create!(
  name: '一般ユーザー',
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

admin_user = User.create!(
  name: '管理者ユーザー',
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

# 一般ユーザーに関連付けられたタスクを50件作成
50.times do |n|
  user.tasks.create!(
    title: "一般ユーザーのタスク#{n + 1}",
    content: "これは一般ユーザーのタスク#{n + 1}です。",
    deadline_on: Date.today + (n + 1).days,
    priority: rand(0..2), # 0: 低, 1: 中, 2: 高
    status: rand(0..2)   # 0: 未着手, 1: 着手中, 2: 完了
  )
end

# 管理者ユーザーに関連付けられたタスクを50件作成
50.times do |n|
  admin_user.tasks.create!(
    title: "管理者ユーザーのタスク#{n + 1}",
    content: "これは管理者ユーザーのタスク#{n + 1}です。",
    deadline_on: Date.today + (n + 1).days,
    priority: rand(0..2), # 0: 低, 1: 中, 2: 高
    status: rand(0..2)   # 0: 未着手, 1: 着手中, 2: 完了
  )
end
