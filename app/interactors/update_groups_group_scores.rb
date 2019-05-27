# frozen_string_literal: true

class UpdateGroupsGroupScores
  include Interactor

  def call
    group = context.group
    begin
      group_scores = GroupStageService.update_group_scores(group)
      context.object_to_save = group_scores
    rescue StandardError
      context.fail!
    end
  end
end
