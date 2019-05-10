# frozen_string_literal: true

class UpdateGroupsGroupScores
  include Interactor

  def call
    context.object_to_save = GroupStageService.update_group_scores(context.group)
  rescue StandardError
    context.fail!
  end
end
