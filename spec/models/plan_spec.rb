require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'カスタムバリデーション' do
    describe 'end_date_after_start_date' do
      it '終了日が開始日以降の場合は有効' do
        plan = build(:plan, start_at: Date.current, end_at: Date.current + 1.day)
        expect(plan).to be_valid
      end

      it '終了日が開始日と同じ場合は有効' do
        plan = build(:plan, start_at: Date.current, end_at: Date.current)
        expect(plan).to be_valid
      end

      it '終了日が開始日より前の場合は無効' do
        plan = build(:plan, start_at: Date.current, end_at: Date.current - 1.day)
        expect(plan).not_to be_valid
        expect(plan.errors[:end_at]).to include("は開始日以降を指定してください")
      end

      it '開始日または終了日がnilの場合はバリデーションをスキップ' do
        plan = build(:plan, start_at: nil, end_at: Date.current)
        plan.valid?
        expect(plan.errors[:end_at]).not_to include("は開始日以降を指定してください")
      end
    end
  end

  describe '重要なメソッド' do
    describe 'accessible_by?' do
      let(:owner) { create(:user) }
      let(:member) { create(:user) }
      let(:other_user) { create(:user) }
      let(:plan) { create(:plan, user: owner) }

      before do
        # メンバーを追加（after_createコールバックで作成者は自動追加される）
        plan.plan_members.create!(user: member)
      end

      it 'プラン作成者はアクセス可能' do
        expect(plan.accessible_by?(owner)).to be true
      end

      it 'プランメンバーはアクセス可能' do
        expect(plan.accessible_by?(member)).to be true
      end

      it '関係のないユーザーはアクセス不可' do
        expect(plan.accessible_by?(other_user)).to be false
      end
    end

    describe 'participants' do
      let(:owner) { create(:user) }
      let(:member1) { create(:user) }
      let(:member2) { create(:user) }
      let(:plan) { create(:plan, user: owner) }

      before do
        plan.plan_members.create!(user: member1)
        plan.plan_members.create!(user: member2)
      end

      it '作成者とメンバー全員を返す' do
        participants = plan.participants
        expect(participants).to include(owner, member1, member2)
        expect(participants.count).to eq(3)
      end

      it '重複したユーザーは1人として扱う' do
        # distinctが機能していることを確認
        expect(plan.participants.count).to eq(plan.participants.distinct.count)
      end
    end
  end

  describe 'コールバック' do
    describe 'after_create :add_owner_as_member' do
      it 'プラン作成時に作成者がメンバーに自動追加される' do
        user = create(:user)
        
        expect {
          plan = create(:plan, user: user)
        }.to change(PlanMember, :count).by(1)
        
        plan = Plan.last
        expect(plan.members).to include(user)
      end

      it 'プラン作成者は必ずメンバーに含まれる' do
        user = create(:user)
        plan = create(:plan, user: user)
        
        expect(plan.accessible_by?(user)).to be true
      end
    end
  end

  describe '基本的なバリデーション' do
    it '有効なプランが作成できる' do
      plan = build(:plan)
      expect(plan).to be_valid
    end

    it '必須項目が空の場合は無効' do
      plan = build(:plan, title: "", start_at: nil, end_at: nil)
      expect(plan).not_to be_valid
      expect(plan.errors[:title]).to be_present
      expect(plan.errors[:start_at]).to be_present
      expect(plan.errors[:end_at]).to be_present
    end
  end
end
