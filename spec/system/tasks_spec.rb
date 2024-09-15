require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  before do
    # ユーザーとタスク、ラベルの作成
    @user = FactoryBot.create(:user, email: 'test@example.com', password: 'password')
    @task1 = FactoryBot.create(:task, title: 'first_task', deadline_on: '2022-02-18', priority: 'medium', status: 'not_started', user: @user)
    @task2 = FactoryBot.create(:task, title: 'second_task', deadline_on: '2022-02-17', priority: 'high', status: 'in_progress', user: @user)
    @task3 = FactoryBot.create(:task, title: 'third_task', deadline_on: '2022-02-16', priority: 'low', status: 'done', user: @user)
    @label1 = FactoryBot.create(:label, name: 'Label1', user: @user)
    @label2 = FactoryBot.create(:label, name: 'Label2', user: @user)
    FactoryBot.create(:labeling, task: @task1, label: @label1)
    FactoryBot.create(:labeling, task: @task2, label: @label2)
  end

  describe '一覧表示機能' do
    describe 'ソート機能' do
      # 既存のソート機能テスト
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        # 既存のタイトル検索テスト
      end

      context 'ステータスで検索した場合' do
        # 既存のステータス検索テスト
      end

      context 'タイトルとステータスで検索した場合' do
        # 既存のタイトルとステータスの検索テスト
      end
    
      context 'ラベルで検索をした場合' do
        it "そのラベルの付いたタスクがすべて表示される" do
          # ログイン処理
          visit new_session_path
          fill_in 'session_email', with: @user.email
          fill_in 'session_password', with: @user.password
          click_button 'ログイン'

          visit tasks_path
          select 'Label1', from: 'search[label]'
          click_button '検索'

          task_list = all('.task_row')
          puts "検索結果（ラベル）: #{task_list.map(&:text)}"

          expect(task_list[0]).to have_content 'first_task'
          expect(task_list).not_to have_content 'second_task'
          expect(task_list).not_to have_content 'third_task'
        end
      end
    end
  end
end
