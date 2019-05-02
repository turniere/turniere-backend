# frozen_string_literal: true

class GroupStageService
  def self.generate_group_stage(groups)
    raise 'Cannot generate group stage without groups' if groups.length.zero?

    average_group_size = (groups.flatten.length.to_f / groups.length.to_f)
    raise 'Groups need to be equal size' unless (average_group_size % 1).zero?

    groups = groups.map(&method(:get_group_object_from))
    Stage.new level: -1, groups: groups
  end

  def self.get_group_object_from(team_array)
    matches = generate_all_matches_between team_array
    Group.new matches: matches
  end

  def self.generate_all_matches_between(teams)
    matches = []
    matchups = teams.combination(2).to_a
    matchups.each_with_index do |matchup, i|
      match = Match.new state: :not_started,
                        position: i,
                        match_scores: [
                          MatchScore.new(team: matchup.first),
                          MatchScore.new(team: matchup.second)
                        ]
      matches << match
    end
    matches
  end
end
