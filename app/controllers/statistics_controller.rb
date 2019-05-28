# frozen_string_literal: true

class StatisticsController < ApplicationController
  before_action :set_tournament, only: %i[index]

  # GET /tournaments/1/statistics
  def index
    group_stage = @tournament.stages.find_by(level: -1)
    if group_stage
      service = StatisticsService.new group_stage
      render json: {
        most_dominant_score: ActiveModelSerializers::SerializableResource.new(service.most_dominant_score).as_json,
        least_dominant_score: ActiveModelSerializers::SerializableResource.new(service.least_dominant_score).as_json,
        group_scores: ActiveModelSerializers::SerializableResource.new(service.group_scores).as_json
      }
    else
      render json: {}, status: :not_implemented
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
