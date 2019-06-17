# frozen_string_literal: true

class BetSerializer < ApplicationSerializer
  belongs_to :match
  belongs_to :team
end
