class PlansController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = Plan.where(user: current_user) # ユーザーのプランを取得
  end

  def new
    @plans = Plan.new
  end

  def create
    @plans = Plan.new(plan_params)
    @plans.user = current_user # セキュリティ的にも controller で上書きするのがベスト

    if @plans.save
      redirect_to plans_path, notice: 'プランが作成されました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @plan = Plan.find(params[:id]) 
  end

  def edit
  end

  def update
    if @plans.update(plan_params)
      redirect_to @plans, notice: t('plans.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plans = Plan.find(params[:id])
    @plans.destroy
    redirect_to plans_path, notice: "プランを削除しました"
  end

  private

  def set_plan
    @plans = current_user.plans.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title, :description, :start_at, :end_at, :user_id)
  end
end
