class AttachmentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    if value.respond_to?(:each)
      value.each { |attachment| validate_attachment(record, attribute, attachment) }
    else
      validate_attachment(record, attribute, value)
    end
  end

  private

  def validate_attachment(record, attribute, attachment)
    if options[:maximum] && attachment.blob.byte_size > options[:maximum]
      recors.errors.add(attribute, "のファイルサイズが大きすぎます(最大#{options[:maximum] / 1.megabyte}MBまで)")
    end

    if options[:content_type] && !attachment.blob.content_type.match?(options[:content_type])
      record.errors.add(attribute, "の形式が正しくありません(JPEG、PND、GIFのみ対応)")
    end

    if options[:purge] && attachment.blob.byte_size == 0
      record.errors.add(attribute, "が空のファイルです")
    end
  end
end
