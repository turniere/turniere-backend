# frozen_string_literal: true

class TournamentSerializer < SimpleTournamentSerializer
  has_many :teams
  has_many :stages
end
