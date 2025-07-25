class Memory < ApplicationRecord
  belongs_to :memory_folder
  belongs_to :user
end
