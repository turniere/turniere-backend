# frozen_string_literal: true

RSpec.describe AdvanceTeamsInIntermediateStage do
  shared_examples_for 'succeeding context' do
    it 'succeeds' do
      expect(context).to be_a_success
    end
  end

  shared_examples_for 'failing context' do
    it 'fails' do
      expect(context).to be_a_failure
    end
  end

  context 'intermediate_stage is nil' do
    let(:context) do
      AdvanceTeamsInIntermediateStage.call(intermediate_stage: nil)
    end

    it_behaves_like 'succeeding context'

    it 'doesn\'t call PopulateMatchBelow' do
      expect(PopulateMatchBelowAndSave).not_to receive(:call)
      context
    end
  end

  context 'intermediate_stage is a realistic stage' do
    let(:context) do
      AdvanceTeamsInIntermediateStage.call(intermediate_stage: create(:playoff_stage, match_type: :single_team_match))
    end

    context 'PopulateMatchBelow succeeds' do
      before do
        expect(class_double('PopulateMatchBelowAndSave').as_stubbed_const(transfer_nested_constants: true))
          .to receive(:call).exactly(4).times.and_return(double(:context, success?: true))
      end

      it_behaves_like 'succeeding context'
    end

    context 'PopulateMatchBelow fails' do
      before do
        expect(class_double('PopulateMatchBelowAndSave').as_stubbed_const(transfer_nested_constants: true))
          .to receive(:call).and_return(double(:context, success?: false))
      end

      it_behaves_like 'failing context'
    end
  end
end
