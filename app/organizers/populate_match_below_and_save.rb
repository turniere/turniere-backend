# frozen_string_literal: true

class PopulateMatchBelowAndSave
  include Interactor::Organizer

  organize PopulateMatchBelow, SaveApplicationRecordObject
end
