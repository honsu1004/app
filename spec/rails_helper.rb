require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# FactoryBotの設定
require 'factory_bot_rails'

RSpec.configure do |config|
  # FactoryBotのメソッドを使えるようにする
  config.include FactoryBot::Syntax::Methods
  
  # Deviseのヘルパー（必要に応じて）
  config.include Devise::Test::IntegrationHelpers, type: :request
  
  # 基本設定
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
