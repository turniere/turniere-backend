# frozen_string_literal: true

class UpdateMatchScore
  include Interactor

  def call
    match_score = context.match_score
    match_score_params = context.match_score_params
    if match_score.update(match_score_params)
      context.fail! unless match_score.save
    else
      context.fail!
    end
  end
end
