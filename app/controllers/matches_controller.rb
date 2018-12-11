# frozen_string_literal: true

class MatchesController < ApplicationController
  # GET /matches/1
  def show
    render json: Match.find(params[:id]), include: ['match_scores.points', 'match_scores.team']
  end
end
