# frozen_string_literal: true

class StartMatch
  include Interactor

  def call
    match = context.match
    begin
      match = MatchService.start_match(match)
      context.object_to_save = match
    rescue StandardError
      context.fail!
    end
  end
end
