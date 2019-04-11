# frozen_string_literal: true

class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action -> { require_owner! @tournament.owner }, only: %i[update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

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
    params = tournament_params
    params.require(:teams)
    # convert teams parameter into Team objects
    teams = params.delete('teams').map do |team|
      if team.key? 'id'
        Team.find team[:id]
      elsif team.key? 'name'
        Team.create name: team[:name]
      end
    end
    # create tournament
    tournament = current_user.tournaments.new params
    # associate provided teams with tournament
    tournament.teams = teams
    # validate tournament
    unless tournament.valid?
      render json: tournament.errors, status: :unprocessable_entity
      return
    end
    # add playoff stage to tournament
    result = AddPlayoffsToTournamentAndSaveTournamentToDatabase.call(tournament: tournament)
    # return appropriate result
    if result.success?
      render json: result.tournament, status: :created, location: result.tournament
    else
      render json: { error: 'Tournament generation failed' }, status: :unprocessable_entity
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
    params.slice(:name, :description, :public, :teams).permit!
  end
end
