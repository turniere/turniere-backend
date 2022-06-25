# frozen_string_literal: true

class HealthController < ApplicationController
  def index
    errors = []
    errors << 'database not conneected' unless database_connected?
    status = errors.empty? ? :ok : :internal_server_error
    render json: { errors: }, status:
  end

  private

  def database_connected?
    ApplicationRecord.connection.select_value('SELECT 1') == 1
  rescue StandardError
    false
  end
end
