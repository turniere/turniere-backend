# frozen_string_literal: true

class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :matches, dependent: :destroy
  has_many :groups, dependent: :destroy

  def teams
    if groups.size.zero?
      return matches.map(&:teams).flatten.uniq
    elsif matches.size.zero?
      return groups.map(&:teams).flatten.uniq
    end

    []
  end
end
