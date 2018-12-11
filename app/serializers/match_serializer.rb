# frozen_string_literal: true

class MatchSerializer < ApplicationSerializer
  attributes :state, :position

  has_many :match_scores
end
