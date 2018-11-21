# frozen_string_literal: true

class ScoreSerializer < ApplicationSerializer
  attributes :score

  has_one :team
end
