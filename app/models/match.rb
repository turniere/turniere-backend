# frozen_string_literal: true

class Match < ApplicationRecord
  enum state: %i[single_team not_ready not_started in_progress finished undecided]

  belongs_to :stage, optional: true
  belongs_to :group, optional: true
  has_many :match_scores, dependent: :destroy

  validates :match_scores, length: { maximum: 2 }

  validate :stage_xor_group

  def teams
    match_scores.map(&:team).flatten.uniq
  end

  def owner
    stage ? stage.owner : group.owner
  end

  def current_leading_team
    return nil if match_scores.first.points == match_scores.second.points

    match_scores.max_by(&:points).team
  end

  def winner
    finished? ? current_leading_team : nil
  end

  def group_match?
    group.present?
  end

  def scored_points_of(team)
    teams.include?(team) ? match_scores.find_by(team: team).points : 0
  end

  def received_points_of(team)
    teams.include?(team) ? match_scores.find { |ms| ms.team != team }.points : 0
  end

  def group_points_of(team)
    return 0 unless (finished? || in_progress?) && teams.include?(team)

    case current_leading_team
    when team
      3
    when nil
      1
    else
      0
    end
  end

  private

  def stage_xor_group
    errors.add(:stage_xor_group, 'Stage and Group missing or both present') unless stage.present? ^ group.present?
  end
end
