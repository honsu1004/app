class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # /users/sign_up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :full_name])
  end

  def after_sign_in_path_for(resource)
    plans_path # 旅行計画一覧のパスに変更
  end

  private

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end
end
