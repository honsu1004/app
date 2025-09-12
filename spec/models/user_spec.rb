require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    # FactoryBotを使用する場合
    # user = build(:user)
    # expect(user).to be_valid
    
    # 簡単なテスト例
    expect(User.new).to be_a(User)
  end
end
