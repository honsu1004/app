module ApplicationHelper
  def safe_url(url)
    return "#" if url.blank?
    
    begin
      uri = URI.parse(url)
      # HTTPまたはHTTPSのURLのみ許可
      return url if uri.scheme.in?(%w[http https])
    rescue URI::InvalidURIError
      # 無効なURLの場合はデフォルトに戻す
    end
    
    "#"
  end
end
