# frozen_string_literal: true

class Match < ApplicationRecord
  enum status: %i[team1_won team2_won undecided in_progress not_started]

  belongs_to :stage
  belongs_to :group
  has_many :scores, dependent: :destroy

  validates :scores, length: { maximum: 2 }

  def evaluate_status
    if score_team1 < score_team2
      :team2_won
    elsif score_team2 < score_team1
      :team1_won
    else
      group_match? ? :undecided : :in_progress 
    end
  end

  def group_match?
    group.present?
  end
end
