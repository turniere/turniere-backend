# frozen_string_literal: true

class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :match
  belongs_to :team, optional: true
end
