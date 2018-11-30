# frozen_string_literal: true

class MatchSerializer < ApplicationSerializer
  attributes :state

  has_many :match_scores
end
