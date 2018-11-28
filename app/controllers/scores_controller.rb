# frozen_string_literal: true

class ScoresController < ApplicationController
  before_action :set_score, only: %i[show update]
  before_action :authenticate_user!, only: %i[update]
  before_action -> { require_owner! @score.owner }, only: %i[update]

  # GET /scores/1
  def show
    render json: @score
  end

  # PATCH/PUT /scores/1
  def update
    if @score.update(score_params)
      render json: @score
    else
      render json: @score.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_score
    @score = Score.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def score_params
    deserialize_params only: %i[score]
  end
end
