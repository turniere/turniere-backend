# frozen_string_literal: true

class GroupStageService
  def self.generate_group_stage(groups)
    return false if groups.length.zero?
    average_group_size = (groups.map{ |g| g.teams }.flatten.length.to_f / groups.length.to_f)
    if (average_group_size %1).zero?
      groups = groups.map { |group| get_group_object_from(group) }
      group_stage = Stage.new level: -1, groups: groups
      group_stage
    else
      false
    end
  end

  def self.get_group_object_from(team_array)
    matches = generate_all_matches_between team_array
    group = Group.new matches: matches
    group
  end

  def self.generate_all_matches_between(teams)
    matches = []
    matchups = teams.combination(2).to_a
    matchups.each_with_index do |matchup, i|
      match = Match.new state: :not_started,
                        position: i,
                        match_scores: [
                          MatchScore.create(team: matchup.first),
                          MatchScore.create(team: matchup.second)
                        ]
      matches << match
    end
    matches
  end
end
