# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :tournament, optional: true
  has_many :group_scores, dependent: :destroy
  has_many :match_scores, dependent: :destroy

  validates :name, presence: true

  delegate :owner, to: :tournament
end
