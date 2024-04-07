# frozen_string_literal: true

class GroupSerializer < ApplicationSerializer
  attributes :number
  attributes :group_scores

  has_many :matches

  def group_scores
    sorted_group_scores = object.group_scores.sort_by do |x|
      # sort sorts from smallest to largest, therefore we need to negate the values
      [
        -x.group_points, -(x.scored_points - x.received_points), -x.scored_points
      ]
    end
    sorted_group_scores.map { |group_score| GroupScoreSerializer.new(group_score) }
  end
end
