# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  private

  def require_owner! owner
    render_forbidden_error if owner != current_user
  end

  def render_forbidden_error
    render json: {
      errors: [
        'Only the parent tournament owner can update this resource'
      ]
    }, status: :forbidden
  end
end
