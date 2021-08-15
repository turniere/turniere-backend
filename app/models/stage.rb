# frozen_string_literal: true

class Stage < ApplicationRecord
  enum state: { playoff_stage: 0, intermediate_stage: 1, in_progress: 2, finished: 3 }

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

  def over?
    return matches.find { |m| m.state != 'finished' }.nil? unless matches.size.zero?

    unless groups.size.zero? && groups.map(&:matches).flatten.size.zero?
      return groups.map(&:matches).flatten.find { |m| m.state != 'finished' }.nil?
    end

    false
  end
end
