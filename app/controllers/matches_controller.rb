# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show update]
  before_action :validate_params, only: %i[update]
  before_action -> { require_owner! @match.owner }, only: %i[update]
  before_action :set_tournament, only: %i[index]

  # GET/tournaments/1/matches
  def index
    matches = if match_params['state'].nil?
                @tournament.matches

              # support for upcoming matches for beamer view
              elsif match_params['state'] == 'upcoming'
                # for every group within the tournament find the match with the lowest position that is of state 'not_started'
                upcoming_matches = @tournament.stages.find_by(level: -1)&.groups&.map { |g| g.matches.select { |m| m.state == 'not_started' }.min_by(&:position) }
                # if there are none, the group stage is over, so we have to look into the playoff stages
                if upcoming_matches.nil?
                  next_level = 0
                  @tournament.stages.sort_by(&:level).reverse_each do |stage|
                    # the following if equates to true if it finds a stage where all matches are of state `in_progress`
                    if stage.matches.reject { |m| m.state == 'in_progress' }.nil?
                      next_level = stage.level - 1
                      break
                    end
                  end
                  @tournament.stages.find_by(level: next_level).matches
                else
                  upcoming_matches
                end
              else
                @tournament.matches.select do |m|
                  m.state == match_params['state']
                end
              end
    render json: matches, each_serializer: ExtendedMatchSerializer, include: [
      'match_scores.team', 'bets', 'stage', 'group'
    ]
  end

  # GET /matches/1
  def show
    render json: @match, include: ['match_scores.points', 'match_scores.team', 'bets']
  end

  # PATCH/PUT /matches/1
  def update
    new_state = match_params['state']

    Match.transaction do
      if @match.update(match_params)
        handle_match_end if new_state == 'finished'
        if @match.group_match? and new_state == "in_progress"
          UpdateGroupsGroupScoresAndSave.call(group: @match.group)
        end

        render json: @match
      else
        render json: @match.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def handle_match_end
    UpdateGroupsGroupScoresAndSave.call(group: @match.group) if @match.group_match?
    return if @match.group_match?

    if @match.winner.nil?
      render json: { error: 'Stopping undecided Matches isn\'t allowed in playoff stage' },
             status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end

    return if PopulateMatchBelowAndSave.call(match: @match).success?

    render json: { error: 'Moving Team one stage down failed' },
           status: :unprocessable_entity
    raise ActiveRecord::Rollback
  end

  def validate_params
    case match_params['state']
    when 'in_progress'
      render json: { error: 'Match can\'t start in this state' }, status: :unprocessable_entity \
        unless @match.not_started?
    when 'finished'
      render json: { error: 'Match can\'t finish in this state' }, status: :unprocessable_entity \
        unless @match.in_progress?
    else
      render json: { error: 'Invalid target state' }, status: :unprocessable_entity
    end
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def match_params
    params.slice(:state).permit!
  end
end
