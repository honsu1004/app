class ChatMessage < ApplicationRecord
  belongs_to :plan
  belongs_to :user
  broadcasts_to ->(message) { "chat_#{message.plan_id}" }, inserts_by: :prepend
end
