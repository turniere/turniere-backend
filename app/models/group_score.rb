# frozen_string_literal: true

class GroupScore < ApplicationRecord
  belongs_to :team
  belongs_to :group

  def difference_in_points
    scored_points - received_points
  end
end
