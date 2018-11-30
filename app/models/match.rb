# frozen_string_literal: true

class Match < ApplicationRecord
  enum state: %i[single_team not_ready not_started in_progress finished undecided]

  belongs_to :stage, optional: true
  belongs_to :group, optional: true
  has_many :match_scores, dependent: :destroy

  validates :match_scores, length: { maximum: 2 }

  validate :stage_xor_group

  def evaluate_match_result
    if match_scores.first == match_scores.second
      if group_match?
        :undecided
      else
        :in_progress
      end
    else
      :finished
    end
  end

  private

  def stage_xor_group
    errors.add(:stage_xor_group, 'Stage and Group missing or both present') unless stage.present? ^ group.present?
  end

  def group_match?
    group.present?
  end
end
