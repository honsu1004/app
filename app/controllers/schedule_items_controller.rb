class ScheduleItemsController < ApplicationController
  before_action :set_plan
  before_action :authorize_member!, only: [ :edit, :update, :destroy ]

  def index
    @schedule_items = @plan.schedule_items.ordered
  end

  def update_positions
    ActiveRecord::Base.transaction do
      params[:positions].each do |item_data|
        item = @plan.schedule_items.find(item_data[:id])
        item.update!(
          position: item_data[:position],
          day_number: item_data[:day_number]
        )
      end
    end
  
    render json: { status: 'success', message: '順序を更新しました' }
  rescue ActiveRecord::RecordNotFound => e
    render json: { status: 'error', message: 'スケジュールアイテムが見つかりません' }, status: :not_found
  rescue => e
    render json: { status: 'error', message: '更新に失敗しました' }, status: :unprocessable_entity
  end

  def new
    @plan = Plan.find(params[:plan_id])
    @schedule_item = @plan.schedule_items.new
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @schedule_item = @plan.schedule_items.new(schedule_item_params)
    @schedule_item.user = current_user  # ← user_id をセット
    @schedule_item.user_id = current_user.id

    if @schedule_item.save
      redirect_to plan_schedule_items_path(@plan), notice: "スケジュールを追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @plan = Plan.find(params[:plan_id])
    @schedule_item = @plan.schedule_items.find(params[:id])
  end

  def update
    @schedule_item = ScheduleItem.find(params[:id])

    if @schedule_item.update(schedule_item_params)
      redirect_to plan_schedule_items_path(@schedule_item.plan), notice: "スケジュールを更新しました" # ここでリダイレクト
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule_item = @plan.schedule_items.find(params[:id])
    @schedule_item.destroy
    redirect_to plan_schedule_items_path(@plan), notice: "スケジュールを削除しました"
  end

  def show
    @schedule_item = @plan.schedule_items.find(params[:id])
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def schedule_item_params
    params.require(:schedule_item).permit(:day_number, :start_time, :end_time, :memo, :location_name, :url, :position)
  end

  def authorize_member!
    # 例: planのメンバーまたは作成者だけ許可
    unless @plan.users.include?(current_user) || @plan.user == current_user
      redirect_to root_path, alert: "権限がありません。"
    end
  end
end
