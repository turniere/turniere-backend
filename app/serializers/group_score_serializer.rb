# frozen_string_literal: true

class GroupScoreSerializer < ApplicationSerializer
  attributes :group_points, :received_points, :scored_points, :position, :difference_in_points

  belongs_to :team
end
