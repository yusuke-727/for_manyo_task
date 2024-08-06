require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:task1) { FactoryBot.create(:task, title: 'first_task', deadline_on: '2022-02-18', priority: 'medium', status: 'not_started') }
  let!(:task2) { FactoryBot.create(:task, title: 'second_task', deadline_on: '2022-02-17', priority: 'high', status: 'in_progress') }
  let!(:task3) { FactoryBot.create(:task, title: 'third_task', deadline_on: '2022-02-16', priority: 'low', status: 'done') }

  before do
    puts "生成されたタスク1: #{task1.inspect}"
    puts "生成されたタスク2: #{task2.inspect}"
    puts "生成されたタスク3: #{task3.inspect}"
  end

  describe '一覧表示機能' do
    describe 'ソート機能' do
      context '終了期限というリンクをクリックした場合' do
        it '終了期限順に並び替えられたタスク一覧が表示される' do
          visit tasks_path
          puts "タスク一覧ページのHTML（ソート前）: #{page.body}"
          click_link '終了期限'
          puts "タスク一覧ページのHTML（ソート後）: #{page.body}"
          task_list = all('.task_row')
          puts "タスク一覧（終了期限順）: #{task_list.map(&:text)}"
          expect(task_list[0]).to have_content 'third_task'
          expect(task_list[1]).to have_content 'second_task'
          expect(task_list[2]).to have_content 'first_task'
        end
      end

      context '優先度というリンクをクリックした場合' do
        it '優先度の高い順に並び替えられたタスク一覧が表示される' do
          visit tasks_path
          puts "タスク一覧ページのHTML（ソート前）: #{page.body}"
          click_link '優先度'
          puts "タスク一覧ページのHTML（優先度ソート後）: #{page.body}"
          task_list = all('.task_row')
          puts "タスク一覧（優先度順）: #{task_list.map(&:text)}"
          expect(task_list[0]).to have_content 'second_task'
          expect(task_list[1]).to have_content 'first_task'
          expect(task_list[2]).to have_content 'third_task'
        end
      end
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it '検索ワードを含むタスクのみ表示される' do
          visit tasks_path
          fill_in 'search_title', with: 'first'
          click_button '検索'
          puts "検索結果ページのHTML（タイトル検索）: #{page.body}"
          task_list = all('.task_row')
          puts "検索結果（タイトル）: #{task_list.map(&:text)}"
          expect(task_list[0]).to have_content 'first_task'
          expect(task_list).not_to have_content 'second_task'
          expect(task_list).not_to have_content 'third_task'
        end
      end

      context 'ステータスで検索した場合' do
        it '検索したステータスに一致するタスクのみ表示される' do
          visit tasks_path
          select '未着手', from: 'search_status'
          click_button '検索'
          puts "検索結果ページのHTML（ステータス検索）: #{page.body}"
          task_list = all('.task_row')
          puts "検索結果（ステータス）: #{task_list.map(&:text)}"
          expect(task_list[0]).to have_content 'first_task'
          expect(task_list).not_to have_content 'second_task'
          expect(task_list).not_to have_content 'third_task'
        end
      end

      context 'タイトルとステータスで検索した場合' do
        it '検索ワードをタイトルに含み、かつステータスに完全一致するタスクのみ表示される' do
          visit tasks_path
          fill_in 'search_title', with: 'second'
          select '着手中', from: 'search_status'
          click_button '検索'
          puts "検索結果ページのHTML（タイトルとステータス検索）: #{page.body}"
          task_list = all('.task_row')
          puts "検索結果（タイトルとステータス）: #{task_list.map(&:text)}"
          expect(task_list[0]).to have_content 'second_task'
          expect(task_list).not_to have_content 'first_task'
          expect(task_list).not_to have_content 'third_task'
        end
      end
    end
  end
end
