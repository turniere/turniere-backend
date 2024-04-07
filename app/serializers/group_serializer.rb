# frozen_string_literal: true

class GroupSerializer < ApplicationSerializer
  attributes :number
  attributes :group_scores

  has_many :matches

  def group_scores
    object.group_scores.sort.map { |group_score| GroupScoreSerializer.new(group_score) }
  end
end
