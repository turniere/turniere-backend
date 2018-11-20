# frozen_string_literal: true

class ChangeMatchScore
  include Interactor

  def call
    match = context.match
    match.score_team1 = context.score_team1
    match.score_team2 = context.score_team2
    match.status = match.evaluate_status
    match.save
    context.match = match
  end
end
