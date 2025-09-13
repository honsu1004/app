module PlansHelper
  def can_delete_item?(plan, item, current_user)
    # プラン作成者は全てのアイテムを削除可能
    return true if plan.user == current_user

    # 個人アイテムは本人のみ削除可能
    return true if !item.is_shared && item.assignee == current_user

    # 共有アイテムも参加者なら削除可能
    return true if item.is_shared && plan.participants.include?(current_user)

    false
  end
end
