# frozen_string_literal: true

class Tournament < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  belongs_to :user
end
