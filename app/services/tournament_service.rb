# frozen_string_literal: true

class TournamentService
  class << self
    def calculate_amount_of_teams_advancing(playoff_teams_amount, amount_of_groups)
      # the amount of whole places that advance in a group (e. g. all 1rst places of every group instantly go through)
      instant_finalists_amount = (playoff_teams_amount.floor / amount_of_groups.floor) * amount_of_groups.floor
      # the amount of teams that still need to play an intermediate round before advancing to playoffs
      intermediate_round_participants_amount = (playoff_teams_amount - instant_finalists_amount) * 2

      [instant_finalists_amount, intermediate_round_participants_amount]
    end
  end
end
