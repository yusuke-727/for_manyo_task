require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  before do
    @task = FactoryBot.create(:task)
    @second_task = FactoryBot.create(:second_task)
  end

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'Title', with: '新しいタスク'
        fill_in 'Content', with: '新しいタスクの内容'
        click_button 'Create Task'

        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_content '新しいタスク'
        expect(page).to have_content '新しいタスクの内容'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content '書類作成'
        expect(page).to have_content 'メール送信'
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        visit tasks_path(@task)
        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する。'

        visit tasks_path(@second_task)
        expect(page).to have_content 'メール送信'
        expect(page).to have_content '顧客へ営業のメールを送る。'
      
      end
     end
  end
end