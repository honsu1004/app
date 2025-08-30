class ChecklistItemsController < ApplicationController
  before_action :set_plan
  before_action :set_checklist_item, only: [:update, :destroy]
  before_action :authorize_member!, only: [:index, :new, :create, :update, :destroy]

  def index
    @plan = Plan.find(params[:plan_id])

    case @item_type
    when 'shared'
      @checklist_items = @plan.checklist_items.shared
    when 'personal'
      @checklist_items = @plan.checklist_items.personal
    else
      @checklist_items = @plan.checklist_items
    end
  end

  def new
    @checklist_item = @plan.checklist_items.build
    @item_type = params[:item_type] || 'shared'
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @checklist_item = @plan.checklist_items.build(checklist_item_params)
    @checklist_item.user = current_user

    if @checklist_item.save
      redirect_to plan_checklist_items_path(@plan, item_type: @checklist_item.item_type), notice: '持ち物が追加されました！'
    else
      redirect_to plan_checklist_items_path(@plan, item_type: @checklist_item.item_type), alert: '持ち物の追加に失敗しました！'
    end
  end

  def update
    if @checklist_item.update(checklist_item_params)
      redirect_to plan_checklist_items_path(@plan, item_type: @checklist_item.item_type), notice: '持ち物が更新されました！'
    else
      render :edit
    end
  end

  def destroy
    item_type = @checklist_item.item_type
    @checklist_item.destroy # 削除処理
    redirect_to plan_checklist_items_path(@checklist_item.plan, item_type: item_type), notice: '持ち物が削除されました！'
  end

  private

  def set_plan
    @plan = current_user.plans.find(params[:plan_id])
  end

  def set_checklist_item
    @checklist_item = @plan.checklist_items.find(params[:id])
  end

  def authorize_member!
    @plan = Plan.find(params[:plan_id])
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end

  def checklist_item_params
    params.require(:checklist_item).permit(:name, :is_checked, :item_type)
  end

  def toggle
    @item = ChecklistItem.find(params[:id])
    @item.update(checked: !@item.checked)
    redirect_to plan_checklist_items_path(@item.plan)
  end
end
