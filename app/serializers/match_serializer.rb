# frozen_string_literal: true

class MatchSerializer < ApplicationSerializer
  attributes :state, :position, :winner

  def winner
    ActiveModelSerializers::SerializableResource.new(object.winner).as_json
  end

  # def bets
  #   ActiveModelSerializers::SerializableResource.new(object.bets, serializer: BetsSerializer).as_json
  # end

  has_many :match_scores
  # has_many :bets
end
