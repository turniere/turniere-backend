# frozen_string_literal: true

class PopulateMatchBelow
  include Interactor

  def call
    match = context.match
    begin
      PlayoffStageService.populate_match_below(match)
      context.object_to_save = match
    rescue StandardError
      context.fail!
    end
  end
end
