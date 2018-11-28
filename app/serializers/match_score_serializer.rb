# frozen_string_literal: true

class MatchScoreSerializer < ApplicationSerializer
  attributes :points

  has_one :team
  has_one :match
end
