# frozen_string_literal: true

class MatchScore < ApplicationRecord
  belongs_to :match
  belongs_to :team

  delegate :owner, to: :match
end
