# frozen_string_literal: true

class GroupStageService
  class << self
    def generate_group_stage(groups)
      raise 'Cannot generate group stage without groups' if groups.length.zero?

      # raise an error if the average group size is not a whole number
      raise 'Groups need to be equal size' unless (groups.flatten.length.to_f / groups.length % 1).zero?

      groups = groups.map(&method(:get_group_object_from)).each_with_index { |group, i| group.number = i + 1 }
      Stage.new level: -1, groups: groups, state: :in_progress
    end

    def get_group_object_from(team_array)
      Group.new matches: generate_all_matches_between(team_array),
                group_scores: team_array.map { |team| GroupScore.new team: team }
    end

    def deal_with_spacing_of_teams(matches, team_size)
      # matches are generated like so (example for a 4 team group stage):
      # 0: a - b
      # 1: a - c
      # 2: a - d
      # 3: b - c
      # 4: b - d
      # 5: c - d
      #
      # If you were to play a tournament strictly in that order, team a would play three games in a row.
      #
      # To deal with this, we switch game 1 and 5 which results in the following order:
      #
      # 0: a - b
      # 1: c - d
      # 2: a - d
      # 3: b - c
      # 4: b - d
      # 5: a - c
      #
      # This should also be optimal, as the first and second game don't have any team in common, meaning that everyone
      # gets to play as soon as possible.
      # Also, there is only two teams that need to play two games back to back (1-2 d, 3-4 b).
      #
      # This problem is only fixed for a group size of 4, because we did not come up with a generalized version of this
      # switcharoo magic and we needed it for groups of 4.
      return unless team_size == 4

      matches[5].position, matches[1].position = matches[1].position, matches[5].position
      matches
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
      deal_with_spacing_of_teams(matches, teams.size)
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
      recalculate_position_of_group_scores!(changed_group_scores)
    end

    # Returns a list of the teams in the group sorted by their group_points, difference_in_points, scored_points
    #
    # @param group Group the group to get the teams from
    # @return [Array] of teams
    def teams_sorted_by_group_scores(group)
      group.group_scores.sort.map(&:team)
    end

    # Returns all teams advancing to playoff stage from given group stage
    # They are ordered in such a way, that PlayoffStageService will correctly match the teams
    #
    # @param group_stage GroupStage the group stage to get all advancing teams from
    # @return [Array] the teams advancing from that group stage
    def get_advancing_teams(group_stage)
      advancing_teams = []
      group_winners = group_stage.groups.map(&method(:teams_sorted_by_group_scores))
      (group_stage.tournament.instant_finalists_amount + group_stage.tournament.intermediate_round_participants_amount)
        .times do |i|
        advancing_teams << group_winners[i % group_stage.groups.size].shift
      end
      advancing_teams
    end

    private

    def recalculate_position_of_group_scores!(group_scores)
      group_scores = group_scores.sort

      rank = 1
      previous = nil
      group_scores.each_with_index do |group_score, i|
        comparison = i.zero? ? 1 : group_score <=> previous

        case comparison
        when 1
          rank = i + 1
          group_score.position = rank
        when 0
          group_score.position = rank
        else
          raise # should not happen, list is sorted
        end
        previous = group_score
      end

      group_scores
    end
  end
end
