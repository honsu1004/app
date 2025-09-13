require 'rails_helper'

RSpec.describe 'Protected Pages', type: :request do
  let(:user) { create(:user) }

  describe 'GET /users/edit' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        get edit_user_registration_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインしている場合' do
      before { sign_in user }

      it 'ユーザー編集ページが表示される' do
        get edit_user_registration_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'ログイン済みユーザーの認証ページアクセス' do
    before { sign_in user }

    it 'ログインページにアクセスするとリダイレクトされる' do
      get new_user_session_path
      expect(response).to redirect_to(plans_path)
    end

    it '新規登録ページにアクセスするとリダイレクトされる' do
      get new_user_registration_path
      expect(response).to redirect_to(plans_path)
    end
  end
end
