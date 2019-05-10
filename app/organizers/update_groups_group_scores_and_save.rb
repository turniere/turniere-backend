# frozen_string_literal: true

class UpdateGroupsGroupScoresAndSave
  include Interactor::Organizer

  organize UpdateGroupsGroupScores, SaveApplicationRecordObject
end
