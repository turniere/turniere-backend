# frozen_string_literal: true

class GroupScoreSerializer < ApplicationSerializer
  attributes :group_points, :received_points, :scored_points

  belongs_to :team
end
