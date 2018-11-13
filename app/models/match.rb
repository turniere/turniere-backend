# frozen_string_literal: true

class Match < ApplicationRecord
  enum status: %i[team1_won team2_won undecided in_progress not_started]

  belongs_to :stage
  belongs_to :group
  has_many :scores, dependent: :destroy

  validates :scores, length: { maximum: 2 }
end
