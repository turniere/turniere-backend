# frozen_string_literal: true

RSpec.describe UpdateMatchScore do
  before do
    @match_score = create(:running_playoff_match).match_scores.first
    @match_score_params = { points: 42 }
  end

  context 'save succeeds' do
    let(:context) do
      UpdateMatchScore.call(match_score: @match_score, match_score_params: @match_score_params)
    end

    before do
      expect_any_instance_of(MatchScore)
        .to receive(:save).and_return(true)
      expect_any_instance_of(MatchScore)
        .to receive(:update).with(@match_score_params).and_return(true)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the match score' do
      expect(context.match_score).to eq(@match_score)
    end
  end

  context 'save fails' do
    let(:context) do
      UpdateMatchScore.call(match_score: @match_score, match_score_params: @match_score_params)
    end

    before do
      expect_any_instance_of(MatchScore)
        .to receive(:save).and_return(false)
    end

    it 'fails' do
      test = context.failure?
      expect(test).to eq(true)
    end
  end

  context 'update fails' do
    let(:context) do
      UpdateMatchScore.call(match_score: @match_score, match_score_params: @match_score_params)
    end

    before do
      expect_any_instance_of(MatchScore)
        .to receive(:update).and_return(false)
    end

    it 'fails' do
      test = context.failure?
      expect(test).to eq(true)
    end
  end
end
