# frozen_string_literal: true

class GroupScore < ApplicationRecord
  belongs_to :team
  belongs_to :group

  def difference_in_points
    scored_points - received_points
  end

  def <=>(other)
    point_comparison = [-position, -group_points, -difference_in_points, -scored_points] <=> [-other.position, -other.group_points, -other.difference_in_points, -other.scored_points]
    if point_comparison.zero?
      comparison_match = group.matches.find do |match|
        match.match_scores.any? { |match_score| match_score.team == team }
      end
      comparison_match.scored_points_of(team) <=> comparison_match.scored_points_of(other.team)
    else
      point_comparison
    end
  end
end
