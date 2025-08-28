module ApplicationHelper
  def sort_items_by_time(items)
    items.sort_by do |item|
      if item.start_time.present?
        item.start_time
      else
        Time.current.end_of_day
      end
    end
  end
end
