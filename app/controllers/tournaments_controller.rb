# frozen_string_literal: true

class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action -> { require_owner! @tournament.owner }, only: %i[update destroy]
  before_action :validate_create_params, only: %i[create]
  before_action :validate_update_params, only: %i[update]
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
      params.require(:playoff_teams_amount)
      groups = organize_teams_in_groups(teams)
      # add groups to tournament
      result = AddGroupStageToTournamentAndSave.call(tournament: tournament, groups: groups)
    else
      # convert teams parameter into Team objects
      teams = teams.map(&method(:find_or_create_team))
      # associate provided teams with tournament
      tournament.teams = teams
      # add playoff stage to tournament
      result = AddPlayoffsToTournamentAndSave.call(tournament: tournament)
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

  def organize_teams_in_groups(teams)
    # each team gets put into a array of teams depending on the group specified in team[:group]
    teams.group_by { |team| team['group'] }.values.map do |group|
      group.map do |team|
        find_or_create_team(team)
      end
    end
  end

  def find_or_create_team(team)
    # convert teams parameter into Team objects
    if team[:id]
      Team.find team[:id]
    elsif team[:name]
      Team.create name: team[:name]
    end
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def index_params
    params.permit(:type)
  end

  def tournament_params
    params.slice(:name, :description, :public, :teams, :group_stage, :playoff_teams_amount).permit!
  end

  def validate_create_params
    teams = params['teams']
    return if teams.is_a?(Array) && teams.reject { |t| t.is_a? ActionController::Parameters }.count.zero?

    render json: { error: 'Invalid teams array' }, status: :unprocessable_entity
  end

  def only_playoff_teams_amount_changed
    params['playoff_teams_amount'] &&
      params['instant_finalists_amount'].nil? &&
      params['intermediate_round_participants_amount'].nil?
  end

  def validate_update_params
    return if only_playoff_teams_amount_changed

    playoff_teams_amount = params['playoff_teams_amount'].to_i || @tournament.playoff_teams_amount
    instant_finalists_amount = params['instant_finalists_amount'].to_i || @tournament.instant_finalists_amount
    intermediate_round_participants_amount = params['intermediate_round_participants_amount'].to_i ||
                                             @tournament.intermediate_round_participants_amount

    return if instant_finalists_amount + (intermediate_round_participants_amount / 2) ==
              playoff_teams_amount

    render json: {
      error: 'playoff_teams_amount, instant_finalists_amount and intermediate_round_participants_amount don\'t match'
    }, status: :unprocessable_entity
  end
end
