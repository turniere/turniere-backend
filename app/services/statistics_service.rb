# frozen_string_literal: true

class StatisticsService
  def initialize(stage)
    raise 'Unsupported stage type' if stage.nil? || stage.groups.empty?

    @stage = stage
    @group_scores = sort_group_scores(@stage.groups, :group_points)

    @most_dominant_score = sort_group_scores(@stage.groups, :scored_points).first
    @least_dominant_score = sort_group_scores(@stage.groups, :received_points).first
  end

  attr_reader :group_scores
  attr_reader :most_dominant_score
  attr_reader :least_dominant_score

  private

  def sort_group_scores(groups, by)
    groups
      .map(&:group_scores).flatten # collect all group scores
      .sort_by(&by).reverse
  end
end
