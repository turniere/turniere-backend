# frozen_string_literal: true

class StatisticsService
  def initialize(stage)
    raise 'Unsupported stage type' if stage.nil? || stage.groups.empty?

    @stage = stage
  end

  def group_scores
    sort_group_scores(@stage.groups, :group_points)
  end

  def most_dominant_score
    sort_group_scores(@stage.groups, :scored_points).first
  end

  def least_dominant_score
    sort_group_scores(@stage.groups, :received_points).first
  end

  private

  # Sort group scores associated with `groups` by GroupScore#`attr`
  # in descending order
  #
  # @param groups [Array] Groups to take GroupScore objects from
  # @param attr [Symbol] GroupScore attribute to sort by
  # @return [Array] Sorted array of group scores
  def sort_group_scores(groups, attr)
    groups
      .map(&:group_scores).flatten # collect all group scores
      .sort_by(&attr).reverse
  end
end
