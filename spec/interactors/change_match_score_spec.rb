# frozen_string_literal: true

describe ChangeMatchScore do
  subject(:context) do
    @match = create(:match)
    @score_team1 = 4
    @score_team2 = 2
    @expected_match_status = :team1_won
    ChangeMatchScore.call(match: @match, score_team1: @score_team1, score_team2: @score_team2)
  end

  before do
    allow(Match).to receive(:save).and_return(true)
    allow(Match).to receive(:evaluate_status).and_return(@expected_match_status)
  end

  it 'succeeds' do
    expect(context).to be_a_success
  end

  it 'changes match score accordingly' do
    expect(context.match.score_team1).to eq(@score_team1)
    expect(context.match.score_team2).to eq(@score_team2)
  end

  it 'changes match state accordingly' do
    expect(context.match.status).to eq(@expected_match_status)
  end
end
