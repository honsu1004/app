class ChecklistItemsController < ApplicationController
  before_action :set_plan
  before_action :set_checklist_item, only: [:update, :destroy]
  before_action :authorize_member!, only: [:index, :new, :create, :update, :destroy]

  def index
    @plan = Plan.find(params[:plan_id])
    @item_type = params[:item_type] || 'shared'

    if @item_type == 'shared'
      @checklist_items = @plan.checklist_items.where(item_type: 'shared')
    else
      @checklist_items = @plan.checklist_items.where(item_type: 'personal', user: current_user)
    end
    
    @checklist_item = ChecklistItem.new
  end

  def new
    @checklist_item = @plan.checklist_items.build
    @item_type = params[:item_type] || 'shared'
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @checklist_item = @plan.checklist_items.build(checklist_item_params)
    @checklist_item.user = current_user
    @checklist_item.item_type = params[:checklist_item][:item_type] || 'personal'

    if @checklist_item.save
      redirect_to plan_checklist_items_path(@plan, item_type: @checklist_item.item_type), notice: '持ち物が追加されました！'
    else
      @item_type = @checklist_item.item_type
      @checklist_items = load_checklist_items(@item_type)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @checklist_item.shared?
      @checklist_item.toggle_check_for_user!(current_user)
      redirect_to plan_checklist_items_path(@plan, item_type: 'shared'), notice: '持ち物が更新されました！'
    else
      # 個人アイテムの場合は、UserChecklistItemを使用
      @checklist_item.toggle_check_for_user!(current_user)
      redirect_to plan_checklist_items_path(@plan, item_type: 'personal')
    end
  end

  def destroy
    item_type = @checklist_item.item_type
    @checklist_item.destroy # 削除処理
    redirect_to plan_checklist_items_path(@plan, item_type: item_type), notice: '持ち物が削除されました！'
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

  def load_checklist_items(item_type)
    if item_type == 'shared'
      @plan.checklist_items.where(item_type: 'shared')
    else
      @plan.checklist_items.where(item_type: 'personal', user: current_user)
    end
  end
end
