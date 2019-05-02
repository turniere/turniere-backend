# frozen_string_literal: true

class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :matches, dependent: :destroy
  has_many :groups, dependent: :destroy

  def teams
    return matches.map(&:teams).flatten.uniq unless matches.size.zero?

    groups.map(&:teams).flatten.uniq unless groups.size.zero?
  end
end
