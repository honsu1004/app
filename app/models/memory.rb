class Memory < ApplicationRecord
  belongs_to :memory_folder
  belongs_to :user
  has_many_attached :media

  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'は有効なURLを入力してください' }, allow_blank: true

  validates :media, attachment: {
    purge: true,
    content_type: %r{\Aimage/(png|jpeg|gif)\Z},
    maximum: 2.megabytes
  }

  before_destroy :purge_media

  private

  def purge_media
    media.purge
  end
  # validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
end
