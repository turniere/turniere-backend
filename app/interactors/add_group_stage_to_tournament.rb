# frozen_string_literal: true

class AddGroupStageToTournament
  include Interactor

  def call
    tournament = context.tournament
    groups = context.groups
    context.fail! unless tournament.stages.empty?
    begin
      group_stage = GroupStageService.generate_group_stage(groups)
      tournament.stages = [group_stage]
      context.object_to_save = tournament
    rescue StandardError
      context.fail!
    end
  end
end
