# frozen_string_literal: true

class MatchScoreSerializer < ApplicationSerializer
  attributes :points

  belongs_to :team
end
