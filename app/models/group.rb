# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :matches
  belongs_to :teams
end
