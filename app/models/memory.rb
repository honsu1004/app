class Memory < ApplicationRecord
  belongs_to :memory_folder
  belongs_to :user

  # dependent: :destroy_laterで関連ファイルも自動削除
  has_many_attached :media, dependent: :destroy_later

  validate :validate_media_presence
  validate :validate_media_size_and_format

  validates :url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "正しいURLを入力してください"
  }, allow_blank: true

  private

  def validate_media_presence
    errors.add(:media, "を選択してください") unless media.attached?
  end

  def validate_media_size_and_format
    return unless media.attached?

    allowed_types = [ "image/jpeg", "image/png", "image/gif", "image/webp" ]
    max_size = 5.megabytes

    media.each do |file|
      # ファイルサイズチェック
      if file.blob.byte_size > max_size
        errors.add(:media, "のファイルサイズが大きすぎます（最大: 5MB）")
      end

      # ファイル形式チェック
      unless allowed_types.include?(file.blob.content_type)
        errors.add(:media, "のファイル形式が無効です（JPEG, PNG, GIF, WebP のみ対応）")
      end
    end
  end
end
