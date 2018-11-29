# frozen_string_literal: true

class SaveTournamentToDatabase
  include Interactor

  def call
    if context.tournament.save
      nil
    else
      context.fail!
    end
  end
end
