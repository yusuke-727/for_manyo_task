require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in 'name', with: 'テストユーザ'
        fill_in 'email', with: 'test@example.com'
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'password'
        click_button '登録する'
        expect(page).to have_content 'タスク一覧ページ'
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user) }

    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        visit login_path
        fill_in 'session_email', with: user.email  # 修正箇所
        fill_in 'session_password', with: user.password  # 修正箇所
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content 'タスク一覧ページ'
      end

      it '自分の詳細画面にアクセスできる' do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password

        click_button 'ログイン'
        # ページが遷移したか確認
        expect(page).to have_content 'ログインしました'
  
        visit user_path(user)
        expect(page).to have_content user.name
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        other_user = FactoryBot.create(:user)
        # ログイン処理を実際のフォームを使って行う
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'

        # ログインが成功してタスク一覧ページに遷移しているか確認
        expect(page).to have_content 'タスク一覧ページ'

        # 他のユーザの詳細ページにアクセス
        visit user_path(other_user)

        # タスク一覧ページにリダイレクトされているか確認
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_content '管理者以外アクセスできません'
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        visit login_path
        fill_in 'session_email', with: user.email  # 修正箇所
        fill_in 'session_password', with: user.password  # 修正箇所
        click_button 'ログイン'
        click_link 'sign-out'
        expect(page).to have_content 'ログアウトしました'
        expect(page).to have_current_path login_path
      end
      
    end
  end

  describe '管理者機能' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }
    let!(:user) { FactoryBot.create(:user) }

    context '管理者がログインした場合' do
      before do
        Capybara.reset_sessions!  # 既存のセッションをクリア
        visit new_session_path
        fill_in 'session_email', with: admin_user.email
        fill_in 'session_password', with: admin_user.password
        click_button 'ログイン'
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content 'ユーザ一覧ページ'
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in 'name', with: '新しい管理者'
        fill_in 'email', with: 'admin_new@example.com'
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'password'
        check 'user_admin'
        click_button '登録する'
        expect(page).to have_content 'ユーザを登録しました'
        expect(page).to have_content '新しい管理者'
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user)
        expect(page).to have_content user.name
        expect(page).to have_content user.email
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(user)
        fill_in 'name', with: '編集済みユーザ'
        fill_in 'password', with: 'newpassword'
        fill_in 'password-confirmation', with: 'newpassword' 
        click_button '更新する'
        expect(page).to have_content 'ユーザ情報を更新しました'
        expect(page).to have_content '編集済みユーザ'
      end

      it 'ユーザを削除できる' do
        # 先に別の管理者ユーザーを作成
        another_admin = FactoryBot.create(:admin_user, email: 'another_admin@example.com')
  
        # ログアウト処理を追加
        click_link 'ログアウト'

        visit login_path
        fill_in 'session_email', with: another_admin.email
        fill_in 'session_password', with: another_admin.password
        click_button 'ログイン'      
        
        visit admin_users_path
        click_link '削除', match: :first
        page.driver.browser.switch_to.alert.accept
        
        expect(page).to have_content 'ユーザを削除しました'
      end
      
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'
      end

      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_content '管理者以外アクセスできません'
        expect(page).to have_current_path tasks_path
      end
    end
  end
end
