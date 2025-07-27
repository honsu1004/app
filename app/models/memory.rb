class Memory < ApplicationRecord
  belongs_to :memory_folder
  belongs_to :user

  has_one_attached :media

  before_destroy :purge_media

  private

  def purge_media
    media.purge
  end
  # validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
end
