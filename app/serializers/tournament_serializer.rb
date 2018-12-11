# frozen_string_literal: true

class TournamentSerializer < SimpleTournamentSerializer
  attributes :description
  has_many :stages
  has_many :teams
end
