# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :tournament, optional: true
  has_many :group_scores, dependent: :destroy
  has_many :match_scores, dependent: :destroy

  validates :name, presence: true

  def owner
    match_scores.first.owner
    # this will produce errors if we make teams reusable
  end
end
