class ScheduleItemsController < ApplicationController
  before_action :set_plan

  def index
    @schedule_items = @plan.schedule_items.order(:day_number, :start_time)
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end

