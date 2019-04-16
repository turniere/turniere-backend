# frozen_string_literal: true

class MatchScoresController < ApplicationController
  before_action :set_match_score, only: %i[show update]
  before_action :authenticate_user!, only: %i[update]
  before_action -> { require_owner! @match_score.owner }, only: %i[update]

  # GET /scores/1
  def show
    render json: @match_score
  end

  # PATCH/PUT /scores/1
  def update
    result = UpdateMatchScore.call(match_score: @match_score, match_score_params: match_score_params)
    if result.success?
      render json: @match_score
    else
      render json: @match_score.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match_score
    @match_score = MatchScore.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def match_score_params
    params.slice(:points).permit!
  end
end
