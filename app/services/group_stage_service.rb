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
      teams_per_group_ranked = group_stage.groups.map(&method(:teams_sorted_by_group_scores))
      advancing_teams_amount = calculate_advancing_teams_amount(group_stage)
      tournament_teams_amount = group_stage.tournament.teams.size

      if special_case_for_po2?(tournament_teams_amount, advancing_teams_amount)
        handle_special_case(teams_per_group_ranked)
      else
        handle_default_case(teams_per_group_ranked, advancing_teams_amount, group_stage.groups.size)
      end
    end

    private

    # Calculates the total number of teams advancing to the playoff stage
    #
    # @param group_stage GroupStage the group stage to get the advancing teams amount from
    # @return [Integer] the number of teams advancing from that group stage
    def calculate_advancing_teams_amount(group_stage)
      group_stage.tournament.instant_finalists_amount +
        group_stage.tournament.intermediate_round_participants_amount
    end

    # Checks if the special case for po2 teams in the tournament applies
    #
    # @param tournament_teams_amount [Integer] the total number of teams in the tournament
    # @param advancing_teams_amount [Integer] the number of teams advancing to the playoff stage
    # @return [Boolean] true if the special case applies, false otherwise
    def special_case_for_po2?(tournament_teams_amount, advancing_teams_amount)
      Utils.po2?(tournament_teams_amount) && advancing_teams_amount * 2 == tournament_teams_amount
    end

    # Handles the special case for po2 teams in the tournament
    #
    # @param teams_per_group_ranked [Array] a 2D array of teams ranked by group scores
    # @return [Array] the teams advancing from the group stage
    def handle_special_case(teams_per_group_ranked)
      # transpose the array to group first and second places together
      # e.g. [[1, 2, 3], [4, 5, 6]] to [[1, 4], [2, 5], [3, 6]]
      teams_per_group_ranked_transposed = teams_per_group_ranked.transpose
      first_places = teams_per_group_ranked_transposed[0]
      second_places = teams_per_group_ranked_transposed[1]

      second_places_new_order = Utils.split_and_rotate(second_places)

      # zip the first and second places together
      # e.g. [1, 2, 3], [a, b, c] to [1, a, 2, b, 3, c]
      first_places.zip(second_places_new_order).flatten
    end

    # Handles the default case for advancing teams
    #
    # @param teams_per_group_ranked [Array] a 2D array of teams ranked by group scores
    # @param advancing_teams_amount [Integer] the number of teams advancing to the playoff stage
    # @param groups_size [Integer] the number of groups in the group stage
    # @return [Array] the teams advancing from the group stage
    def handle_default_case(teams_per_group_ranked, advancing_teams_amount, groups_size)
      advancing_teams = []
      advancing_teams_amount.times do |i|
        advancing_teams << teams_per_group_ranked[i % groups_size].shift
      end
      advancing_teams
    end

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
