# frozen_string_literal: true

class StatisticsController < ApplicationController
  before_action :set_tournament, only: %i[index]

  # GET /tournaments/1/statistics
  def index
    group_stage = @tournament.stages.find_by(level: -1)
    if group_stage
      service = StatisticsService.new group_stage
      render json: {
        most_dominant_score: service.most_dominant_score,
        least_dominant_score: service.least_dominant_score,
        group_scores: service.group_scores
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
