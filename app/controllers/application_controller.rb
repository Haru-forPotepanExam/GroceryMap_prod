class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_q

  private

  def after_sign_in_path_for(resource)
    profile_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def set_q
    @q = Price.ransack(params[:q])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
