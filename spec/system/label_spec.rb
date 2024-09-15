require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'password') }

  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        # ログイン処理
        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'

        # ラベルの新規作成
        visit new_label_path
        fill_in 'label_name', with: '新しいラベル'
        click_button '登録する'
        
        # ラベルが正しく表示されるか確認
        expect(page).to have_content '新しいラベル'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        # テストデータの作成
        FactoryBot.create(:label, name: 'テストラベル', user: user)
        
        # ログイン処理
        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'

        # ラベル一覧ページに遷移
        visit labels_path
        
        # ラベルが表示されているか確認
        expect(page).to have_content 'テストラベル'
      end
    end
  end
end