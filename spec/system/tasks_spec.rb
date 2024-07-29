require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  # テストデータをlet!を使って定義
  let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: Time.now) }
  let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: Time.now - 1.day) }
  let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: Time.now - 2.days) }

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'タイトル', with: '新しいタスク'
        fill_in '内容', with: '新しいタスクの内容'
        click_button '登録する'

        expect(page).to have_content 'タスクを登録しました'
        expect(page).to have_content '新しいタスク'
        expect(page).to have_content '新しいタスクの内容'
      end
    end
  end

  describe '一覧表示機能' do
    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        expect(page).to have_content 'first_task'
        expect(page).to have_content 'second_task'
        expect(page).to have_content 'third_task'
      end

      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')

        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in 'タイトル', with: '新しいタスク'
        fill_in '内容', with: '新しいタスクの内容'
        click_button '登録する'
        visit tasks_path

        task_list = all('tbody tr')
        expect(task_list[0]).to have_content '新しいタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        visit task_path(first_task)
        expect(page).to have_content 'first_task'
        expect(page).to have_content first_task.content

        visit task_path(second_task)
        expect(page).to have_content 'second_task'
        expect(page).to have_content second_task.content
      end
    end
  end
end
