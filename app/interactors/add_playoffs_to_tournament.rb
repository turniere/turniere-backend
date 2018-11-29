# frozen_string_literal: true

class AddPlayoffsToTournament
  include Interactor

  def call
    tournament = context.tournament
    context.fail! if tournament.stages.size > 1
    if (playoff_stages = PlayoffStageService.generate_playoff_stages_from_tournament(tournament))
      if tournament.stages.empty?
        tournament.stages = playoff_stages
      else
        tournament.stages.concat playoff_stages
      end
      context.tournament = tournament
    else
      context.fail!
    end
  end
end