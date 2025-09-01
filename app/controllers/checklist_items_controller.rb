class ChecklistItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan
  before_action :check_plan_access

  def index
    @item_type = params[:item_type] || 'shared'
    
    if @item_type == 'shared'
      # 共有アイテムをユーザーごとにグループ化
      shared_items = @plan.checklist_items.where(is_shared: true).includes(:assignee)
      @grouped_items = @plan.participants.map do |user|
        {
          user: user,
          items: shared_items.where(assignee: user),
          is_current_user: user == current_user
        }
      end
    else
      # 個人アイテム（現在のユーザーのみ）
      @personal_items = @plan.checklist_items.where(
        is_shared: false, 
        assignee: current_user
      )
    end
  end

  def create
    @checklist_item = @plan.checklist_items.build(checklist_item_params)
    
    # 個人アイテムの場合は自動的に現在のユーザーを担当者に設定
    if !@checklist_item.is_shared
      @checklist_item.assignee = current_user
    end

    if @checklist_item.save
      redirect_to plan_checklist_items_path(@plan, item_type: params[:checklist_item][:is_shared] == 'true' ? 'shared' : 'personal'),
                  notice: 'アイテムが追加されました'
    else
      # エラーがある場合は再度indexを表示
      @item_type = params[:checklist_item][:is_shared] == 'true' ? 'shared' : 'personal'
      if @item_type == 'shared'
        shared_items = @plan.checklist_items.where(is_shared: true).includes(:assignee)
        @grouped_items = @plan.participants.map do |user|
          {
            user: user,
            items: shared_items.where(assignee: user),
            is_current_user: user == current_user
          }
        end
      else
        @personal_items = @plan.checklist_items.where(
          is_shared: false, 
          assignee: current_user
        )
      end
      render :index
    end
  end

  def update
    @checklist_item = ChecklistItem.find(params[:id])

    # item_typeを確実に取得
    item_type = params[:item_type] ||
                params.dig(:checklist_item, :item_type) ||
                @checklist_item.item_type

    if @checklist_item.update(checklist_item_params)
      respond_to do |format|
        # 修正：item_type変数を使用する
        format.html { redirect_to plan_checklist_items_path(@plan, item_type: item_type) }
        format.js   { render json: { status: 'success', checked: @checklist_item.checked } }
      end
    else
      respond_to do |format|
        # 修正：item_type変数を使用する
        format.html { 
          redirect_to plan_checklist_items_path(@plan, item_type: item_type), 
                      alert: '更新に失敗しました' 
        }
        format.js   { render json: { status: 'error'} }
      end
    end
  end

  def destroy
    @checklist_item = @plan.checklist_items.find(params[:id])
    
    # 削除権限チェック
    if can_delete_item?(@checklist_item)
      @checklist_item.destroy
      redirect_to plan_checklist_items_path(@plan, item_type: params[:item_type]),
                  notice: 'アイテムが削除されました'
    else
      redirect_to plan_checklist_items_path(@plan, item_type: params[:item_type]),
                  alert: '削除権限がありません'
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def check_plan_access
    unless @plan.participants.include?(current_user)
      redirect_to plans_path, alert: 'このプランにアクセスする権限がありません'
    end
  end

  def checklist_item_params
    params.require(:checklist_item).permit(:name, :assignee_id, :is_shared, :checked, :item_type)
  end

  def can_delete_item?(item)
    # プラン作成者は全てのアイテムを削除可能
    return true if @plan.user == current_user
    
    # 個人アイテムは本人のみ削除可能
    return true if !item.is_shared && item.assignee == current_user
    
    false
  end

  def authorize_member!
    # @planは既にset_planで設定済み
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end
end
