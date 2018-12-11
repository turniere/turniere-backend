# frozen_string_literal: true

class TournamentSerializer < SimpleTournamentSerializer
  attributes :description
  has_many :stages
  has_many :teams

  attribute :owner_username do
    object.owner.username
  end
end
