# frozen_string_literal: true

require 'match'

class UpdateMatchStatus
  include Interactor

  def call
    context.match.status = evaluate_new_match_state(context.match)
  end

  def evaluate_new_match_state(match)
    score_team1 = match.score_team1
    score_team2 = match.score_team2
    if score_team1 < score_team2
      return Match.team2_won
    elsif score_team2 < score_team1
      return Match.team1_won
    else
      if match.is_group_match
        return Match.undecided
      else
        return Match.in_progress
      end
    end
  end
end
