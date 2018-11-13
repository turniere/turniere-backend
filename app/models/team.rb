# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :tournament

  has_one :group_score, dependent: :destroy
end
