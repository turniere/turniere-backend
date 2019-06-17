# frozen_string_literal: true

class PopulateMatchBelow
  include Interactor

  def call
    match = context.match
    begin
      objects_to_save = PlayoffStageService.populate_match_below(match)
      (context.object_to_save ||= []) << objects_to_save
    rescue StandardError
      context.fail!
    end
  end
end
