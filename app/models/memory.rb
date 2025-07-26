class Memory < ApplicationRecord
  belongs_to :memory_folder
  belongs_to :user

  has_one_attached :media

  # validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
end
