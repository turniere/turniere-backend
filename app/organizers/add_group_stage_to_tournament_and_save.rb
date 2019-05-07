# frozen_string_literal: true

class AddGroupStageToTournamentAndSave
  include Interactor::Organizer

  organize AddGroupStageToTournament, SaveApplicationRecordObject
end
