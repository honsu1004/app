class PlanMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def invite
    user = User.find_by(email: params[:email])

    if user.nil?
      redirect_to plan_path(@plan), alert: "ユーザーが見つかりません"
      return
    end

    if @plan.members.include?(user)
      redirect_to plan_path(@plan), alert: "すでにメンバーに追加されています。"
    else
      PlanMember.create!(plan: @plan, user: user, joined_at: Time.current)
      PlanMemberMailer.invite_email(@plan, user, current_user).deliver_later
      redirect_to plan_path(@plan), notice: "メンバーを招待し、メールを送信しました！"
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end
