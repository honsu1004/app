class ChecklistItem < ApplicationRecord
  enum :item_type, { shared: 0, personal: 1 }

  belongs_to :plan
  belongs_to :user
end
