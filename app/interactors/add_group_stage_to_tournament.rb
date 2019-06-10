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
      tournament.instant_finalists_amount, tournament.intermediate_round_participants_amount =
        TournamentService.calculate_default_amount_of_teams_advancing(tournament.playoff_teams_amount,
                                                                      group_stage.groups.size)
      context.object_to_save = tournament
    rescue StandardError
      context.fail!
    end
  end
end
