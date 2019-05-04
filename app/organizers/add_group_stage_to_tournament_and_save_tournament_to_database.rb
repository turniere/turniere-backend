# frozen_string_literal: true

class AddGroupStageToTournamentAndSaveTournamentToDatabase
  include Interactor::Organizer

  organize AddGroupStageToTournament, SaveTournamentToDatabase
end
