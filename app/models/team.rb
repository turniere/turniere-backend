# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :tournament
  has_many :group_scores, dependent: :destroy
  has_many :scores, dependent: :destroy

  validates :name, presence: true

  delegate :owner, to: :tournament
end
