# frozen_string_literal: true

class Match < ApplicationRecord
  enum state: %i[single_team not_ready not_started in_progress finished undecided]

  belongs_to :stage, optional: true
  belongs_to :group, optional: true
  has_many :match_scores, dependent: :destroy

  validates :match_scores, length: { maximum: 2 }

  validate :stage_xor_group

  def teams
    match_scores.map(&:team).flatten.uniq
  end

  def owner
    stage ? stage.owner : group.owner
  end

  def winner
    evaluate_winner
    # This should maybe be cached or put into db
  end

  private

  def evaluate_winner
    return nil if match_scores.first.points == match_scores.second.points

    match_scores.max_by(&:points).team
  end

  def stage_xor_group
    errors.add(:stage_xor_group, 'Stage and Group missing or both present') unless stage.present? ^ group.present?
  end

  def group_match?
    group.present?
  end
end
