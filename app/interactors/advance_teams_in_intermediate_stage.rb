# frozen_string_literal: true

class AdvanceTeamsInIntermediateStage
  include Interactor

  def call
    intermediate_stage = context.intermediate_stage
    return if intermediate_stage.nil?

    intermediate_stage.matches.select { |m| m.state == 'single_team' }
                      .each do |match|
                        context.fail! unless PopulateMatchBelowAndSave.call(match: match).success?
                      end
    (context.object_to_save ||= []) << intermediate_stage
  end
end
