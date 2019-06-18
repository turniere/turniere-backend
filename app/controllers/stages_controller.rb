# frozen_string_literal: true

class StagesController < ApplicationController
  before_action :set_stage, only: %i[show update]
  before_action :authenticate_user!, only: %i[update]
  before_action -> { require_owner! @stage.owner }, only: %i[update]

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
end
