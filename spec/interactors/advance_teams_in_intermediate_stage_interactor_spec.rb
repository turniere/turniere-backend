# frozen_string_literal: true

RSpec.describe AdvanceTeamsInIntermediateStage do
  context 'intermediate_stage is nil' do
    let(:context) do
      AdvanceTeamsInIntermediateStage.call(intermediate_stage: nil)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'doesn\'t call PopulateMatchBelow' do
      expect(PopulateMatchBelowAndSave).not_to receive(:call)
      context
    end
  end
end
