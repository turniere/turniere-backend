# frozen_string_literal: true

class Match < ApplicationRecord
  enum state: %i[single_team not_ready not_started in_progress team1_won team2_won undecided]

  belongs_to :stage, optional: true
  belongs_to :group, optional: true
  has_many :match_scores, dependent: :destroy

  validates :match_scores, length: { maximum: 2 }

  validate :stage_xor_group

  def teams
    match_scores.map(&:team).flatten.uniq
  end

  private

  def stage_xor_group
    errors.add(:stage_xor_group, 'Stage and Group missing or both present') unless stage.present? ^ group.present?
  end

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
