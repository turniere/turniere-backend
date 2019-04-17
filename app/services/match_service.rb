# frozen_string_literal: true

class MatchService
  # Generates all necessary matches from a list of teams
  #
  # @param teams [Array] the teams to generate matches with
  # @return [Array] the generated matches
  def self.generate_matches(teams)
    if teams.size < 2
      # should be prevented by controller
      return
    end

    # normal_games = number of matches with two teams attending
    # needed_games = number of matches to generate in total for the given number of teams
    if Utils.po2?(teams.size)
      # if amount of teams is power of two, all matches are with two teams
      normal_games = teams.size / 2
      needed_games = normal_games
    else
      # if amount of teams isn't a power of two we need to "kick out"
      # enough teams to get to a power of two in the next round
      normal_games = teams.size - Utils.previous_power_of_two(teams.size)
      needed_games = Utils.previous_power_of_two(teams.size)
    end

    matches = []
    while matches.size < normal_games
      # while we do not have as many matches with two teams as we need, create another one
      i = matches.size
      match = Match.new state: :not_started,
                        position: i,
                        match_scores: [
                          MatchScore.create(team: teams[2 * i]),
                          MatchScore.create(team: teams[(2 * i) + 1])
                        ]
      matches << match
    end

    # the start point is to compensate for all the teams that are already within a "normal" match
    startpoint = matches.size
    until matches.size >= needed_games
      # while we do not have enough matches in general we need to fill the array with "single team" matches
      i = matches.size + startpoint
      match = Match.new state: :single_team, position: i, match_scores: [MatchScore.create(team: teams[i])]
      matches << match
    end
    matches
  end
end
