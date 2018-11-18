# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :stage
  belongs_to :group
  has_many :scores, dependent: :destroy
end
