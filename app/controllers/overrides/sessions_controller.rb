# frozen_string_literal: true

module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    def render_create_success
      render json: resource_data(resource_json: @resource.token_validation_response)
    end
  end
end
