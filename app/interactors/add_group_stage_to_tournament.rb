# frozen_string_literal: true

class AddGroupStageToTournament
  include Interactor

  def call
    tournament = context.tournament
    groups = context.groups
    context.fail! if tournament.stages.size > 1
    if (group_stage = GroupStageService.generate_group_stage(groups))
      tournament.stages = [group_stage]
      context.tournament = tournament
    else
      context.fail!
    end
  end
end
