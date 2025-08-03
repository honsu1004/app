class PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan, only: [:show, :edit, :update, :destroy, :invite_members]
  before_action :authorize_member!, only: [:edit, :update, :destroy]

  def index
    # オーナーまたはメンバーのプランを表示
    @plans = Plan.joins(:plan_members)
                 .where("plans.user_id = :uid OR plan_members.user_id = :uid", uid: current_user.id)
                 .distinct
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = current_user.plans.build(plan_params)

    if @plan.save
      redirect_to plans_path, notice: 'プランが作成されました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # set_plan で取得済み
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: "プランを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_path, notice: "プランを削除しました"
  end

  def invite_members
    email = params[:email]
    invitation = @plan.plan_invitations.create!(email: email)
    PlanInvitationMailer.invite(invitation).deliver_later
    redirect_to @plan, notice: "招待メールを送信しました！"
  end

  private

  def set_plan
    # オーナーまたはメンバーであれば取得
    @plan = Plan.joins(:plan_members)
                .where("plans.user_id = :uid OR plan_members.user_id = :uid", uid: current_user.id)
                .distinct
                .find(params[:id])
  end

  def authorize_member!
    unless @plan.user == current_user || @plan.members.include?(current_user)
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end

  def plan_params
    params.require(:plan).permit(:title, :description, :start_at, :end_at)
  end
end
