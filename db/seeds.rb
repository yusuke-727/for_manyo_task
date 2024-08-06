# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
50.times do |i|
    Task.create(
        title: "タスク#{i + 1}",
        content: "タスク#{i + 1}の内容"
    )
end

# 新しい10件のタスクを追加
Task.create!(
  [
    { title: 'first_task', content: '任意の内容1', deadline_on: '2022-02-18', priority: 'medium', status: 'not_started' },
    { title: 'second_task', content: '任意の内容2', deadline_on: '2022-02-17', priority: 'high', status: 'in_progress' },
    { title: 'third_task', content: '任意の内容3', deadline_on: '2022-02-16', priority: 'low', status: 'done' },
    { title: 'fourth_task', content: '任意の内容4', deadline_on: '2022-03-01', priority: 'high', status: 'not_started' },
    { title: 'fifth_task', content: '任意の内容5', deadline_on: '2022-03-02', priority: 'medium', status: 'in_progress' },
    { title: 'sixth_task', content: '任意の内容6', deadline_on: '2022-03-03', priority: 'low', status: 'done' },
    { title: 'seventh_task', content: '任意の内容7', deadline_on: '2022-03-04', priority: 'high', status: 'not_started' },
    { title: 'eighth_task', content: '任意の内容8', deadline_on: '2022-03-05', priority: 'medium', status: 'in_progress' },
    { title: 'ninth_task', content: '任意の内容9', deadline_on: '2022-03-06', priority: 'low', status: 'done' },
    { title: 'tenth_task', content: '任意の内容10', deadline_on: '2022-03-07', priority: 'high', status: 'not_started' }
  ]
)