# frozen_string_literal: true

class Stage < ApplicationRecord
  enum state: %i[playoff_stage intermediate_stage in_progress finished]

  belongs_to :tournament
  has_many :matches, dependent: :destroy
  has_many :groups, dependent: :destroy

  delegate :owner, to: :tournament

  def teams
    if !matches.size.zero?
      matches.map(&:teams).flatten.uniq
    elsif !groups.size.zero?
      groups.map(&:teams).flatten.uniq
    else
      []
    end
  end
end
