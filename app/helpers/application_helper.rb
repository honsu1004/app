module ApplicationHelper
  def sort_items_by_time(items)
    items.sort_by do |item|
      if item.start_time.present?
        [0, item.start_time]
      else
        [1, item.position || 999]
      end
    end
  end
end
