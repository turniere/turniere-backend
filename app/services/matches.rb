module Turniere
  class Matches
    def self.generate_matches(teams)
      if teams.size == 1
        return #TODO error with only one team
      end
      needed_games = 0
      if (Turniere::Utils.po2?(teams.size()) 
          needed_games = teams.size() / 2
      else 
          needed_games = teams.size() - Turniere::Utils.previous_power_of_two(teams.size()) / 2
      end

      lastPos = 0
      matches = []
      i = 0

      while i < needed_games
        match = Match(teams[2 * i], teams[( 2 * i ) + 1], 0, 0, :not_startet, i, false)
        matches.insert match
        i++
      end

      lastPos = i + 1

      while teams.size() != 0 
        match = Match(teams[2 * i], teams[( 2 * i ) + 1], 0, 0, Match, i, false)
        matches.insert match
      end
      return lastPos
    end
  end
end