class ScheduleItemsController < ApplicationController
  before_action :set_plan

  def index
    @schedule_items = @plan.schedule_items.order(:day_number, :start_time)
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

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def schedule_item_params
    params.require(:schedule_item).permit(:day_number, :start_time, :end_time, :address)
  end
end
