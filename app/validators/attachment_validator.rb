class AttachmentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    has_error = false

    if options[:maximum]
      if value.is_a?(ActiveStorage::Attached::Many)
        value.each do |one_value|
          unless validate_maximum(record, attribute, one_value)
            has_error = true
            break
          end
        end
      else
        has_error = true unless validate_maximum(record, attribute, value)
      end
    end

    if options[:content_type]
      if value.is_a?(ActiveStorage::Attached::Many)
        value.each do |one_value|
          unless validate_content_type(record, attribute, one_value)
            has_error = true
            break
          end
        end
      else
        has_error = true unless validate_content_type(record, attribute, value)
      end
    end
  end

  private

  def validate_maximum(record, attribute, value)
    if value.blob.byte_size > options[:maximum]
      record.errors.add(attribute, "のファイルサイズが大きすぎます（最大: #{options[:maximum] / 1.megabyte}MB）")
      return false
    end
    true
  end

  def validate_content_type(record, attribute, value)
    unless options[:content_type].include?(value.blob.content_type)
      record.errors.add(attribute, "のファイル形式が無効です")
      return false
    end
    true
  end
end
