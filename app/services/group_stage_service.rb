# frozen_string_literal: true

class GroupStageService
  class << self
    def generate_group_stage(groups)
      raise 'Cannot generate group stage without groups' if groups.length.zero?

      # raise an error if the average group size is not a whole number
      raise 'Groups need to be equal size' unless (groups.flatten.length.to_f / groups.length.to_f % 1).zero?

      groups = groups.map(&method(:get_group_object_from))
      Stage.new level: -1, groups: groups
    end

    def get_group_object_from(team_array)
      Group.new matches: generate_all_matches_between(team_array),
                group_scores: team_array.map { |team| GroupScore.new team: team }
    end

    def generate_all_matches_between(teams)
      matches = []
      teams.combination(2).to_a # = matchups
           .each_with_index do |matchup, i|
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

    # Updates all group_scores of the given group
    #
    # @param group Group the group to update the group_scores in
    # @return [Array] the changed group_scores that need to be saved
    def update_group_scores(group)
      changed_group_scores = []
      group.teams.each do |team|
        group_score = group.group_scores.find_by(team: team)
        matches = group.matches.select { |match| match.teams.include? team }
        # reset previous values
        group_score.group_points = 0
        group_score.scored_points = 0
        group_score.received_points = 0
        matches.each do |match|
          # calculate points for every match
          group_score.group_points += match.group_points_of team
          group_score.scored_points += match.scored_points_of team
          group_score.received_points += match.received_points_of team
        end
        changed_group_scores << group_score
      end
      changed_group_scores
    end
  end
end
