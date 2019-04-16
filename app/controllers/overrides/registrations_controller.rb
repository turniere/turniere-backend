# frozen_string_literal: true

module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    def render_create_success
      render json: resource_data
    end

    def render_update_success
      render json: resource_data
    end
  end
end
