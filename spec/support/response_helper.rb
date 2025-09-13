module ResponsHelper
  def json_response
    JSON.parse(response.body)
  end
end

Rspec.configure do |config|
  config.include ResponsHelper, type: :request
end
