require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: '今日やること', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.new(title: '今日やること', content: '企画書を作成する。')
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    before do
      @task1 = FactoryBot.create(:task, title: 'first_task', deadline_on: '2022-02-18', priority: 'medium', status: 'not_started')
      @task2 = FactoryBot.create(:task, title: 'second_task', deadline_on: '2022-02-17', priority: 'high', status: 'in_progress')
      @task3 = FactoryBot.create(:task, title: 'third_task', deadline_on: '2022-02-16', priority: 'low', status: 'done')

      puts "タスク1: #{@task1.inspect}"
      puts "タスク2: #{@task2.inspect}"
      puts "タスク3: #{@task3.inspect}"
    end

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it '検索ワードを含むタスクが絞り込まれる' do
        results = Task.search(search: { title: 'first' })
        puts "検索結果: #{results.inspect}"
        expect(results).to include(@task1)
        expect(results).not_to include(@task2)
        expect(results).not_to include(@task3)
        expect(results.count).to eq(1)
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do
        results = Task.search(search: { status: 'not_started' })
        puts "検索結果: #{results.inspect}"
        expect(results).to include(@task1)
        expect(results).not_to include(@task2)
        expect(results).not_to include(@task3)
        expect(results.count).to eq(1)
      end
    end

    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it '検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる' do
        results = Task.search(search: { title: 'second', status: 'in_progress' })
        puts "検索結果: #{results.inspect}"
        expect(results).to include(@task2)
        expect(results).not_to include(@task1)
        expect(results).not_to include(@task3)
        expect(results.count).to eq(1)
      end
    end
  end
end
