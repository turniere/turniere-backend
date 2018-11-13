# frozen_string_literal: true

class ChangeMatchScore
  include Interactor

  def call
    context.match.score_team1 = context.score_team1
    context.match.score_team2 = context.score_team2
  end
end
