# frozen_string_literal: true

class StagesController < ApplicationController
  before_action :set_stage, only: %i[show update]
  before_action :authenticate_user!, only: %i[update]
  before_action -> { require_owner! @stage.owner }, only: %i[update]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

  # GET /stages/1
  def show
    render json: @stage, include: '**'
  end

  # PUT /stages/1
  def update
    if stage_params[:state] == 'finished'
      unless @stage.state == 'in_progress'
        render json: { error: 'Only running group stages can be finished' }, status: :unprocessable_entity
        return
      end

      Stage.transaction do
        if @stage.update(stage_params)
          handle_group_stage_end

          render json: @stage
        else
          render json: @stage.errors, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
    else
      render json: {
        error: 'The state attribute may only be changed to finished'
      }, status: :unprocessable_entity
    end
  end

  def index
    tournament = Tournament.find(params[:tournament_id])
    level_param = index_params[:level]
    if level_param
      if level_param == 'current'
        # TODO: find current stage
      elsif level_param == 'group'
        group_stage = tournament.stages.find_by(level: -1)
        if group_stage
          render json: group_stage
        else
          render json: { error: 'There\'s no group stage for this tournament' }, status: :not_found
        end
      elsif level_param.to_i.to_s == level_param
        render json: tournament.stages.find_by!(level: level_param.to_i)
      else
        render json: { error: 'Invalid level parameter' }, status: unprocessable_entity
      end
    else
      render json: tournament.stages unless level_param
    end
  end

  private

  def handle_group_stage_end
    unless @stage.over?
      render json: {
        error: 'Group Stage still has some matches that are not over yet. Finish them to generate playoffs'
      }, status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end

    return if AddPlayoffsToTournamentAndSave.call(tournament: @stage.tournament,
                                                  teams: GroupStageService.get_advancing_teams(@stage)).success?

    render json: { error: 'Generating group stage failed' }, status: :unprocessable_entity
    raise ActiveRecord::Rollback
  end

  def set_stage
    @stage = Stage.find(params[:id])
  end

  def stage_params
    params.slice(:state).permit!
  end

  def index_params
    params.permit(:level)
  end
end
