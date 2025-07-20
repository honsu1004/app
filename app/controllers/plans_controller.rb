class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = Plan.where(user: current_user) # ユーザーのプランを取得
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user # セキュリティ的にも controller で上書きするのがベスト

    if @plan.save
      redirect_to plans_path, notice: 'プランが作成されました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: t('plans.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to plans_path, notice: "プランを削除しました"
  end

  private

  def set_plan
    @plan = current_user.plans.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title, :description, :start_at, :end_at, :user_id)
  end
end
