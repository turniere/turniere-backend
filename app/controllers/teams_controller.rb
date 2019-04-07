# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[show update]
  before_action :authenticate_user!, only: %i[update]
  before_action -> { require_owner! @team.owner }, only: %i[update]

  # GET /teams/1
  def show
    render json: @team
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.slice(:name).permit!
  end
end
