# frozen_string_literal: true

class MatchesController < ApplicationController
  # GET /matches/1
  def show
    render json: Match.find(params[:id]), include: ['scores.score', 'scores.team'], status: status
  end
end
