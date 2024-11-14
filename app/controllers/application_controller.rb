class ApplicationController < ActionController::API
  # protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  # enable_authorization unless: :devise_controller?
  #
  #
  #   rescue_from StandardError do |exception|
  #     render json: { error: "Internal Server Error", message: exception.message, exception: exception.inspect },
  # status: 500
  #   end

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "Access Denied", message: exception.message }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: "Record not found", message: exception.message }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: { error: "Invalid record", message: exception.message }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotDestroyed do |exception|
    render json: { error: "Record not destroyed", message: exception.message }, status: :unprocessable_entity
  end

  rescue_from ActionController::RoutingError do |exception|
    render json: { error: "Routing Error", message: exception.message }, status: :not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
