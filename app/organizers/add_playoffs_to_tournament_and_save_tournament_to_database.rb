# frozen_string_literal: true

class AddPlayoffsToTournamentAndSaveTournamentToDatabase
  include Interactor::Organizer

  organize AddPlayoffsToTournament, SaveTournamentToDatabase
end
