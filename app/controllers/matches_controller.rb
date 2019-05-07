# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show update]

  # GET /matches/1
  def show
    render json: @match, include: ['match_scores.points', 'match_scores.team']
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end
end
