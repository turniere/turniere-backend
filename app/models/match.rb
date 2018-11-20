# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :stage, optional: true
  belongs_to :group, optional: true
  has_many :scores, dependent: :destroy

  validates :scores, length: { maximum: 2 }

  validate :stage_xor_group

  private

  def stage_xor_group
    errors.add(:stage_xor_group, 'Stage and Group missing or both present') unless stage.present? ^ group.present?
  end
end
