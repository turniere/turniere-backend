# frozen_string_literal: true

class UpdateMatchScore
  include Interactor::Organizer

  organize ChangeMatchScore, UpdateMatchScore
end
