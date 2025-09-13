require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          name: 'テストユーザー',  # 追加
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: '',
          name: '',  # 追加（空にしてバリデーションエラーを発生させる）
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    context '有効なパラメータの場合' do
      it 'ユーザーが作成される' do
        expect {
          post user_registration_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it '成功レスポンスが返される' do
        post user_registration_path, params: valid_params
        expect(response).to have_http_status(:redirect)
      end
    end

    context '無効なパラメータの場合' do
      it 'ユーザーが作成されない' do
        expect {
          post user_registration_path, params: invalid_params
        }.not_to change(User, :count)
      end

      it 'エラーレスポンスが返される' do
        post user_registration_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
