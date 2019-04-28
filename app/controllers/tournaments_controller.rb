# frozen_string_literal: true

class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action -> { require_owner! @tournament.owner }, only: %i[update destroy]
  before_action :validate_create_params, only: %i[create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

  # GET /tournaments
  def index
    type = index_params.fetch(:type, 'public')
    if type == 'public'
      tournaments = Tournament.where(public: true).order(:created_at)
    elsif type == 'private'
      tournaments = Tournament.where(owner: current_user, public: false).order(:created_at)
    else
      # invalid type specified
      render json: { error: 'invalid type' }, status: :bad_request
      return
    end
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
    group_stage = params.delete(:group_stage)
    teams = params.delete('teams')
    # create tournament
    tournament = current_user.tournaments.new params
    if group_stage
      groups = {}
      teams.each do |team|
        team_id = team[:id]
        team_name = team[:name]
        group = team[:group]
        if team_id
          team = Team.find team_id
          put_team_into_groups_hash(groups, team, group)
        elsif team_name
          team = Team.create name: team_name
          put_team_into_groups_hash(groups, team, group)
        end
      end
      # add groups to tournament
      result = AddGroupStageToTournamentAndSaveTournamentToDatabase.call(tournament: tournament, groups: groups.values)
    else
      # convert teams parameter into Team objects
      teams = teams.map do |team|
        if team[:id]
          Team.find team[:id]
        elsif team[:name]
          Team.create name: team[:name]
        end
      end
      # associate provided teams with tournament
      tournament.teams = teams
      # add playoff stage to tournament
      result = AddPlayoffsToTournamentAndSaveTournamentToDatabase.call(tournament: tournament)
    end
    # validate tournament
    unless tournament.valid?
      render json: tournament.errors, status: :unprocessable_entity
      return
    end
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

  def put_team_into_groups_hash(groups, team, group)
    if groups[group].is_a?(Array)
      groups[group] << team
    else
      groups[group] = [team]
    end
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def index_params
    params.permit(:type)
  end

  def tournament_params
    params.slice(:name, :description, :public, :teams, :group_stage).permit!
  end

  def validate_create_params
    teams = params['teams']
    return if teams.is_a?(Array) && teams.reject { |t| t.is_a? ActionController::Parameters }.count.zero?

    render json: { error: 'Invalid teams array' }, status: :unprocessable_entity
  end
end
