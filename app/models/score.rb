# frozen_string_literal: true

class Score < ApplicationRecord
  belongs_to :match
  belongs_to :team
end
