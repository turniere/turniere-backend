# frozen_string_literal: true

class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :matches, dependent: :destroy
  has_many :groups, dependent: :destroy

  def teams
    groups.map{|g| g.matches.map{ |m| m.match_scores.map{ |ms| ms.team}}}.flatten.uniq
  end
end
