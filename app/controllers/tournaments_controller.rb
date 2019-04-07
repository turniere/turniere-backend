# frozen_string_literal: true

class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action -> { require_owner! @tournament.owner }, only: %i[update destroy]

  # GET /tournaments
  def index
    tournaments = Tournament.where(public: true).or(Tournament.where(owner: current_user)).order(:created_at)
    render json: tournaments, each_serializer: SimpleTournamentSerializer
  end

  # GET /tournaments/1
  def show
    render json: @tournament, include: '**'
  end

  # POST /tournaments
  def create
    tournament = current_user.tournaments.new tournament_params

    if tournament.save
      render json: tournament, status: :created, location: tournament
    else
      render json: tournament.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tournaments/1
  def update
    if @tournament.update(tournament_params)
      render json: @tournament
    else
      render json: @tournament.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tournaments/1
  def destroy
    @tournament.destroy
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.permit(:name, :description, :public, :teams)
  end
end
