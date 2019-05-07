# frozen_string_literal: true

class AddPlayoffsToTournamentAndSave
  include Interactor::Organizer

  organize AddPlayoffsToTournament, SaveApplicationRecordObject
end
