require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションテスト' do
    it 'メールアドレスが重複している場合は無効' do
      create(:user, email: "test@example.com")
      duplicate_user = build(:user, email: "test@example.com")

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("は既に使用されています")
    end
  end

  describe 'アソシエーションのテスト' do
    it 'ユーザーが複数のプランを持てること' do
      user = create(:user)

      create(:plan, title: "プラン1", user: user)
      create(:plan, title: "プラン2", user: user)
      create(:plan, title: "プラン3", user: user)


      expect(user.plans.count).to eq(3)
    end

    it 'ユーザーが削除されるとプランも削除されること' do
      user = create(:user)
      create(:plan, user: user)
      create(:plan, user: user)

      expect { user.destroy }.to change(Plan, :count).by(-2)
    end
  end
end
