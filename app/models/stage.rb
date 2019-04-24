# frozen_string_literal: true

class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :matches, dependent: :destroy
  has_many :groups, dependent: :destroy

  def teams
    groups.map{|g| g.teams}.flatten.uniq
  end
end
