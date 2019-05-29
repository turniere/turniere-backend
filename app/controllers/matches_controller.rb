# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show update]
  before_action :validate_params, only: %i[update]
  before_action -> { require_owner! @match.owner }, only: %i[update]

  # GET /matches/1
  def show
    render json: @match, include: ['match_scores.points', 'match_scores.team']
  end

  # PATCH/PUT /matches/1
  def update
    new_state = match_params['state']

    if new_state == 'finished'
      if @match.current_leading_team.nil? # TODO: handle group matches differently
        return render_unprocessable_entity(error: 'Stopping undecided Matches isn\'t allowed in playoff stage')
      end

      unless @match.group_match?
        result = PopulateMatchBelowAndSave.call(match: @match)
        return render_unprocessable_entity(error: 'Moving Team one stage down failed') unless result.success?
      end
    end

    return render json: @match if @match.update(match_params)

    render_unprocessable_entity(@match.errors)
  end

  private

  def render_unprocessable_entity(error_message)
    render json: error_message, status: :unprocessable_entity
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

  def match_params
    params.slice(:state).permit!
  end
end
