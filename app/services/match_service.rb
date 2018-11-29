# frozen_string_literal: true

class MatchService
  def self.generate_matches(teams)
    if teams.size < 2
      # should be prevented by controller
      return
    end

    if Utils.po2?(teams.size)
      normal_games = teams.size / 2
      needed_games = normal_games
    else
      normal_games = teams.size - Utils.previous_power_of_two(teams.size)
      needed_games = Utils.previous_power_of_two(teams.size)
    end

    matches = []
    while matches.size < normal_games
      i = matches.size
      match = Match.new state: :not_started,
                        position: i,
                        scores: [
                          Score.create(team: teams[2 * i]),
                          Score.create(team: teams[(2 * i) + 1])
                        ]
      matches << match
    end

    until matches.size >= needed_games
      i = matches.size
      match = Match.new state: :single_team, position: i, scores: [Score.create(team: teams[i])]
      matches << match
    end
    matches
  end
end
