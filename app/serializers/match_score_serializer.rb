# frozen_string_literal: true

class MatchScoreSerializer < ApplicationSerializer
  attributes :points

  has_one :team
end
