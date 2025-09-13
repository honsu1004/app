require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user, password: 'password123') }

  describe 'GET /users/sign_in' do
    it 'ログインページが表示される' do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /users/sign_in' do
    context '正しい認証情報の場合' do
      it 'ログインが成功する' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'password123'
          }
        }

        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(controller.current_user).to eq(user)
      end
    end

    context '間違った認証情報の場合' do
      it 'ログインが失敗する' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrong_password'
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(controller.current_user).to be_nil
      end
    end
  end
end
