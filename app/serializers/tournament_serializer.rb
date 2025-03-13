# frozen_string_literal: true

class TournamentSerializer < SimpleTournamentSerializer
  attributes :description, :playoff_teams_amount,
             :instant_finalists_amount, :intermediate_round_participants_amount, :timer_end
  has_many :stages
  has_many :teams

  attribute :owner_username do
    object.owner.username
  end
end
