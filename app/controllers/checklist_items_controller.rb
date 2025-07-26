class ChecklistItemsController < ApplicationController
  before_action :authorize_member!, only: [ :index, :create, :destroy ]

  def index
    @plan = Plan.find(params[:plan_id])
    @checklist_items = @plan.checklist_items
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @checklist_item = @plan.checklist_items.new(checklist_item_params)

    if @checklist_item.save
      redirect_to plan_checklist_items_path(@plan), notice: '持ち物が追加されました！'
    else
      render :index
    end
  end

  def update
    checklist_item = ChecklistItem.find(params[:id])
    checklist_item.update(checklist_item_params)
  end

  def destroy
    @checklist_item = ChecklistItem.find(params[:id])
    @checklist_item.destroy # 削除処理
    redirect_to plan_checklist_items_path(@checklist_item.plan), notice: '持ち物が削除されました！'
  end

  def authorize_member!
    @plan = Plan.find(params[:plan_id])
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end

  def checklist_item_params
    params.require(:checklist_item).permit(:name, :is_checked)
  end

  def toggle
    @item = ChecklistItem.find(params[:id])
    @item.update(checked: !@item.checked)
    redirect_to plan_checklist_items_path(@item.plan)
  end
end
