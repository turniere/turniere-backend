# frozen_string_literal: true

class UpdateMatch
  include Interactor::Organizer

  organize ChangeMatchScore
end
